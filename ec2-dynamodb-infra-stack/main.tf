##########################################################################################################################################
# Example AWS resources -  recommend defining your provider blocks and other primary infrastructure in main.tf, you may choose to organize related infrastructure into different files.
##########################################################################################################################################

# This provider block configures the aws provider.

provider "aws" {
  region = "af-south-1"
}

# Generate an SSH key pair locally and register the public key with AWS. Do NOT commit the private key to VCS.
resource "tls_private_key" "learn_terraform_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "learn_terraform_key" {
  key_name   = "learn-terraform-key"
  public_key = tls_private_key.learn_terraform_key.public_key_openssh
}

# Save the private key to a local file with restricted permissions.
resource "local_file" "learn_terraform_priv" {
  content         = tls_private_key.learn_terraform_key.private_key_pem
  filename        = "${path.module}/learn-terraform-key.pem"
  file_permission = "0600"
}

# This data source fetches data about the latest AWS AMI that matches the filter, so you do not have to hardcode the AMI ID into your configuration.

data "aws_ami" "ubuntu" {
  most_recent = true
  # The --owners flag controls whose catalog you're searching
  owners = ["099720109477"] # Canonical's actual AWS account ID, which is how you query official Ubuntu AMIs specifically

  # Filter is used to narrow down the search for the AMI. In this case, it filters for Ubuntu 22.04 AMIs.

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-arm64-server-*"]
  }
}

# A resource block defines components of your infrastructure. The example configuration defines a resource block to create an AWS EC2 instance.

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t4g.small"
  key_name      = "learn-terraform-key" # <-- your key pair name here - note! key pair must be created in the AWS console before running terraform apply, otherwise the EC2 instance will not be created successfully. You can also create a key pair using Terraform, but that is outside the scope of this example.

  # The vpc_security_group_ids argument associates the EC2 instance with the example_sg security group created by the VPC module. The subnet_id argument specifies which subnet to launch the EC2 instance in. In this case, it uses the first public subnet created by the VPC module.
  vpc_security_group_ids = [aws_security_group.example_sg.id]
  subnet_id              = module.vpc.public_subnets[0] # This places the EC2 instance in the first public subnet created by the VPC module. You can also use private_subnets if you want to place the EC2 instance in a private subnet.
  # instance_type = var.instance_type : use  these variables instead of hard-coding the argument values. These are in variables.tf file.

  # The associate_public_ip_address argument associates a public IP address with the EC2 instance.
  associate_public_ip_address = true

  # Instance profile is used to attach the IAM role to the EC2 instance. This allows the EC2 instance to assume the IAM role and access AWS resources as defined by the attached policies.
  iam_instance_profile = aws_iam_instance_profile.app_profile.name

  # The tags argument sets the EC2 instance's name. You can also set other tags for your EC2 instance in the tags argument.

  tags = {
    Name = "learn-terraform"
    # Name = var.instance_name : use  these variables instead of hard-coding the argument values. These are in variables.tf file.
  }
}


