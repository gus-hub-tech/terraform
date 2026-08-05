################################################################################################################################
# Module blocks
# Add a module block to your configuration in main.tf to create a VPC and related networking resources for your EC2 instance.
# This is suppose to be in main.tf but i added it here to make it easier to understand
#################################################################################################################################


# Review the AWS VPC module page in the Terraform Registry, which includes documentation and examples of how to use the module to create networking resources including subnets, security groups, elastic IP addresses, and a NAT gateway.
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

# This configuration defines a VPC named example-vpc with two public and two private subnets.
# Whenever you add a new module to your configuration, you will need to install it by re-initializing the workspace.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["af-south-1a", "af-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_dns_hostnames = true

  # AWS automatically creates a default security group every time a VPC is created
  # Set to false if you'd rather manage the default SG yourself (not recommended)
  manage_default_security_group = true
}

# Terraform automatically resolves dependencies within your configuration, 
# You can organize your configuration blocks in any order you like. 
# As a best practice organize your configuration so that it is easy for you and your team to maintain.