variable "region" {
 default = "eu-central-1"
}

variable "key_name" {
  default = "key4CW"
}

variable "sg_name" {
  default = "sg4CW"
}

variable "instance_type" {
 default = "t2.micro"
}

variable "image_id" {
  default = "ami-0aa72f02ca1be5339"
}

variable "vpc_id" {
  default = "vpc-4d2a8527"
}

variable "subnet_id" {
  default = "subnet-1109d95d"
}
