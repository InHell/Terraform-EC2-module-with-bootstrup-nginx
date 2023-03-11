#v1
output "ec2_ip" {
  description = "ec2_ip"
  value       = resource.aws_instance.env_manager.public_ip
}
