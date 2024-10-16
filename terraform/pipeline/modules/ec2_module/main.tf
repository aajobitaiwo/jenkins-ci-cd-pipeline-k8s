data "aws_ami" "latest" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_filters["name"]]
  }
  filter {
    name   = "virtualization-type"
    values = [var.ami_filters["virtualization-type"]]
  }
  owners = ["amazon"]
}

resource "aws_instance" "ec2_instance" {
  ami                 = data.aws_ami.latest.id
  instance_type       = var.instance_type
  key_name            = var.key_name
  vpc_security_group_ids     = var.security_group_ids
  iam_instance_profile = var.iam_instance_profile
  user_data           = var.user_data

  tags = merge({
    Name = var.instance_name
  }, var.tags)
}