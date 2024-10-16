variable "instance_name" {
   description = "Name of the EC2 instance."
  type        = string
}

variable "ami_filters" {
  description = "Filters for selecting the most recent AMI."
  type        = map(string)
  default     = {
    "name"          = "amzn2-ami-*" # Default to Amazon Linux 2 VM
    "virtualization-type" = "hvm"
  }
}

variable "instance_type" {
  description = "Type of instance to create."
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the EC2 instances."
  type        = list(string)
}

variable "key_name" {
  description = "Key pair to use for the EC2 instances."
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM instance profile for the EC2 instances (if applicable)."
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script to run on instance launch."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the instance."
  type        = map(string)
  default     = {}
}