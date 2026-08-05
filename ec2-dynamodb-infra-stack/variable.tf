###########################################################################################################
# Variables let you parametrize the behavior of your Terraform configuration. 
############################################################################################################

# These input variables allow you to update the EC2 instance's name and type without modifying your configuration files each time. 
# Both variables set a default value for Terraform to use if you do not specify a value for them.

# Define input variables
variable "instance_name" {
  description = "Value of the EC2 instance's Name tag."
  type        = string
  default     = "learn-terraform"
}

# Define input variables
variable "instance_type" {
  description = "The EC2 instance's type."
  type        = string
  default     = "t4g.small"
}

# Define ami input variables
variable "ami_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
  default     = "ami-019e5de836b37e985"
}

# FYI You can set values for your Terraform variables in a number of ways
# 1.environment variables
# 2.command line arguments
# 3.and in files stored on disk.
