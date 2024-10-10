# Output for EC2 Instance ID
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.this.id
}

# Output for EC2 Instance Public IP
output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}

# Output for EC2 Instance Private IP
output "private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.this.private_ip
}

# Output for EC2 Instance Public DNS
output "public_dns" {
  description = "The public DNS of the EC2 instance"
  value       = aws_instance.this.public_dns
}

# Output for EC2 Instance Private DNS
output "private_dns" {
  description = "The private DNS of the EC2 instance"
  value       = aws_instance.this.private_dns
}
