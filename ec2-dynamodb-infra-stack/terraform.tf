########################################################################################################################
# This is the terraform block The terraform {} block configures Terraform itself, including which providers to install, and which version of Terraform to use to provision your infrastructure.
########################################################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}
