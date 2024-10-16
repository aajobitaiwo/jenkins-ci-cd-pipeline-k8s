# Security Group Terraform Module

This module creates multiple security groups in either the default or a specified VPC, with the ability to specify unique names and ingress/egress rules for each security group.

## Inputs

vpc_id: The ID of the VPC where the security group will be created. If not provided, the default VPC will be used.

security_group_names: A list of names for each security group to be created.

ingress_rules: A list of lists, where each inner list defines the ingress rules for a corresponding security group.

#### Each rule should specify:

from_port: The starting port range.

to_port: The ending port range.

protocol: The protocol (e.g., tcp, udp, or -1 for all protocols).

cidr_blocks: The allowed CIDR ranges for this rule (e.g., ["0.0.0.0/0"]).

egress_rules: A list of lists, where each inner list defines the egress rules for a corresponding security group.

#### Each rule should specify:

from_port: The starting port range.

to_port: The ending port range.

protocol: The protocol (e.g., tcp, udp, or -1 for all protocols).

cidr_blocks: The allowed CIDR ranges for this rule (e.g., ["0.0.0.0/0"]).

## Outputs

security_group_ids: A map of the security group IDs created. Each key in the map is the index of the corresponding security group name.

## Usage

```hcl
module "security_group" {
  source = "./security_group_module"

  vpc_id             = "vpc-0a1b2c3d4e"
  security_group_names = ["web-sg", "app-sg", "db-sg"]
  
  ingress_rules = [
    [ # Rules for web-sg
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ],
    [ # Rules for app-sg
      {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ],
    [ # Rules for db-sg
      {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
      }
    ]
  ]

  egress_rules = [
    [ # Egress rules for web-sg
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ],
    [ # Egress rules for app-sg
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ],
    [ # Egress rules for db-sg
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  ]
}

