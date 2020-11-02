terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#set AWS regin
provider "aws" {
  region = "${var.region}"
}

#generate TLS key
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#generate AWS key pair
resource "aws_key_pair" "generated_key" {
  key_name   = "${var.key_name}_${uuid()}"
  public_key = "${tls_private_key.example.public_key_openssh}"
}

#create AWS security group open port SSH & TOMCAT
resource "aws_security_group" "ubuntu" {
  name        = "${var.sg_name}_${uuid()}"
  vpc_id      = "${var.vpc_id}"
  description = "Allow HTTP, HTTPS and SSH traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CW pipeline"
  }
}

#save generated AWS key to localfile
resource "local_file" "cloud_pem" { 
  filename = "${path.module}/key4CW.pem"
  content =  "${tls_private_key.example.private_key_pem}"
  file_permission = "0600"
}

#create aws instance for build, install python for ansible
resource "aws_instance" "build_instance" {
  ami                    = "${var.image_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.ubuntu.id}"]
  subnet_id              = "${var.subnet_id}"
  key_name               = "${aws_key_pair.generated_key.key_name}"
  associate_public_ip_address = true 
  user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install -y python
EOF
  tags = {
    Name = "CW build"
  }
  #save instance publick ip to hosts file for ansible
  provisioner "local-exec" {
    command = "sed -i \"/build/a ${aws_instance.build_instance.public_ip}\" hosts"
  }
}

#create aws instance for production stage, install python for ansible
resource "aws_instance" "stage_instance" {
  ami                    = "${var.image_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.ubuntu.id}"]
  subnet_id              = "${var.subnet_id}"
  key_name               = "${aws_key_pair.generated_key.key_name}"
  associate_public_ip_address = true 
  user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install -y python
EOF
  tags = {
    Name = "CW stage"
  }
  #save instance publick ip to hosts file for ansible
  provisioner "local-exec" {
    command = "sed -i \"/stage/a ${aws_instance.stage_instance.public_ip}\" hosts"
  }  
}