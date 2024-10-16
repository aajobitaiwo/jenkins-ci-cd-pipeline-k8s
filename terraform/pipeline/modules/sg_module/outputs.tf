output "security_group_ids" {
  description = "IDs of the created security groups"
  value       = { for key, sg in aws_security_group.sg : var.security_group_names[key] => sg.id }
}
