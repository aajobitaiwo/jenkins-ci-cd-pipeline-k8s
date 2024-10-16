output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.ec2_instance.private_ip
}