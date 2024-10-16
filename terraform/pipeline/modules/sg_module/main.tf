data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "sg" {
  for_each = { for idx, name in var.security_group_names : idx => name }

  name        = each.value
  vpc_id      = var.vpc_id != null ? var.vpc_id : data.aws_vpc.default.id
  description = "Security group for EC2 instances"

  dynamic "ingress" {
    for_each = var.ingress_rules[each.key]
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules[each.key]
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = each.value
  }
}