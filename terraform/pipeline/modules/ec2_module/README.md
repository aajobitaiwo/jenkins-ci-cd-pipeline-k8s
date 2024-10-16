# EC2 Instances Terraform Module

This module creates a single EC2 instance using the most recent AMI and allows for user-specified options such as instance type, security group, key pair, and user data.

## Inputs

instance_name: Name of the EC2 instance.

instance_type: Type of EC2 instance (e.g., t2.micro, t2.large).

ami_filters: Filters for selecting the most recent AMI.

security_group_ids: List of security group IDs to associate with the instance.

key_name: Name of the SSH key pair to use for instance access.

iam_instance_profile: IAM instance profile to associate with the instance.

user_data: Script to run on instance launch.

tags: A map of key-value pairs for tagging the EC2 instance.

## Outputs

instance_id: The ID of the created EC2 instance.

instance_public_ip: The public IP of the created EC2 instance.

instance_private_ip: The private IP of the created EC2 instance.

## Usage

```hcl
module "ec2_instance" {
  source = "./ec2_module"

  instance_name       = "jenkins-server"
  instance_type       = "t2.large"
  ami_filters         = {
    "name" = "amzn2-ami-hvm-*-x86_64-gp2"
  }
  security_group_ids  = ["sg-12345678"]  # Replace with your actual security group ID
  key_name            = "my-keypair"
  iam_instance_profile = "jenkins-iam-role"
  user_data           = <<-EOF
    #!/bin/bash
    sudo yum install git -y
    git clone https://github.com/<path>.git
    cd jjtech-maven-sonarqube-nexus-prometheus-project/installations
    sh jenkins-install.sh 
  EOF

  tags = {
    "Application" = "jenkins"
    "Environment" = "demo"
  }
}