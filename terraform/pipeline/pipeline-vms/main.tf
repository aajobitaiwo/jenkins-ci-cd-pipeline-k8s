# Create security groups for the i
module "security_group" {
  source = "../modules/sg_module"

  security_group_names = [
    "jenkins-sg",   # Security group for Jenkins VM
    "sonarqube-sg", # Security group for SonarQube VM
    "nexus-sg",     # Security group for Nexus VM
  ]

  ingress_rules = [
    [ # Ingress rules for jenkins-sg (ports 8080, 22)
      {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ],
    [ # Ingress rules for sonarqube-sg (ports 9000, 9100, 22)
      {
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 9100
        to_port     = 9100
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ],
    [ # Ingress rules for nexus-sg (ports 8081, 9100, 22)
      {
        from_port   = 8081
        to_port     = 8081
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 9100
        to_port     = 9100
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  ]

  egress_rules = [
    [ # Egress rules for jenkins-sg (Allow all)
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ],
    [ # Egress rules for sonarqube-sg (Allow all)
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ],
    [ # Egress rules for nexus-sg (Allow all)
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  ]
}

output "security_group_ids" {
  description = "Security group IDs"
  value       = module.security_group.security_group_ids
}

module "jenkins_ec2" {
  source = "../modules/ec2_module"

  instance_name = "jenkins-server"
  instance_type = "t2.large"
  ami_filters = {
    "name"                = "al2023-ami-*"
    "virtualization-type" = "hvm"
  }
  security_group_ids   = [module.security_group.security_group_ids["jenkins-sg"]]
  key_name             = "us-east-1_nova-kp"
  iam_instance_profile = "EC2_w._Admin"
  user_data            = <<-EOF
    #!/bin/bash
    sudo yum install git -y
    git clone https://github.com/anselmenumbisia/jjtech-maven-sonarqube-nexus-prometheus-project.git
    cd jjtech-maven-sonarqube-nexus-prometheus-project/installations
    sh jenkins-install.sh 
  EOF

  tags = {
    "Application" = "jenkins"
    "Environment" = "demo"
  }
}

output "jenkins_instance_id" {
  value = module.jenkins_ec2.instance_id
}

module "sonarqube_ec2" {
  source = "../modules/ec2_module"

  instance_name = "SonarQube"
  instance_type = "t2.medium"
  ami_filters = {
    "name"                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    "virtualization-type" = "hvm"
  }
  security_group_ids = [module.security_group.security_group_ids["sonarqube-sg"]]
  key_name           = "us-east-1_nova-kp"
  user_data          = <<-EOF
    #!/bin/bash
    curl -O https://raw.githubusercontent.com/anselmenumbisia/jjtech-ci-cd-pipeline-project-k8s/main/installation-scripts/sonar.sh
    bash sonar.sh
  EOF

  tags = {
    "Application" = "sonarqube"
    "Environment" = "demo"
  }
}

output "sonarqube_instance_id" {
  value = module.sonarqube_ec2.instance_id
}

module "nexus_ec2" {
  source = "../modules/ec2_module"

  instance_name = "Nexus"
  instance_type = "t2.medium"
  ami_filters = {
    "name"                = "amzn2-ami-*"
    "virtualization-type" = "hvm"
  }
  security_group_ids = [module.security_group.security_group_ids["nexus-sg"]]
  key_name           = "us-east-1_nova-kp"
  user_data          = <<-EOF
    #!/bin/bash
    curl -O https://raw.githubusercontent.com/anselmenumbisia/jjtech-ci-cd-pipeline-project-k8s/main/installation-scripts/nexus.sh
    bash nexus.sh
  EOF

  tags = {
    "Application" = "nexus"
    "Environment" = "demo"
  }
}

output "nexus_instance_id" {
  value = module.nexus_ec2.instance_id
}
