variable "security_group_names" {
  description = "List of names for the security groups."
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created. If not specified, the default VPC will be used."
  type        = string
  default     = null
}

variable "ingress_rules" {
  description = "List of ingress rules to apply to each security group."
  type        = list(list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })))
}

variable "egress_rules" {
  description = "List of egress rules to apply to each security group."
  type        = list(list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })))
}
