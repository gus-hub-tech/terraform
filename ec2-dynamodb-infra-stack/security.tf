#########################################################################################
# This file contains the security group configuration for the example_sg security group.
##########################################################################################

# Create the security group

resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Security group for example_sg"
  vpc_id      = module.vpc.vpc_id # <-- your VPC ID here
}

# Ingress rules for the security group - including SSH access from anywhere

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.example_sg.id
  description       = "SSH access"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0" # restrict to your IP if possible - look up with curl ifconfig.me or search "what is my IP" in your browser. If you are using a VPN, make sure to disconnect from it before running the command.
  # Fix: add /32 to specify "just this one exact IP":
}

# Ingress rules for the security group - including HTTP access 

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.example_sg.id
  description       = "HTTP access"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Ingress rules for the security group - including HTTPS access

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.example_sg.id
  description       = "HTTPS access"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Egress rules for the security group - outbound traffic

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.example_sg.id
  description       = "Allow all outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}