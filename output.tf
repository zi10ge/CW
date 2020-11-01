output "public_ip_of_all_build_instances" {
  description = "List of public IP addresses, if applicable"
  value       = ["${aws_instance.build_instance.*.public_ip}"]
}

output "public_ip_of_all_stage_instances" {
  description = "List of public IP addresses, if applicable"
  value       = ["${aws_instance.stage_instance.*.public_ip}"]
}
