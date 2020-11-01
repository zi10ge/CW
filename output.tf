output "public_ip_of_build_instance" {
  description = "List of public IP addresses, if applicable"
  value       = ["${aws_instance.build_instance.*.public_ip}"]
}

output "public_ip_of_stage_instance" {
  description = "List of public IP addresses, if applicable"
  value       = ["${aws_instance.stage_instance.*.public_ip}"]
}
