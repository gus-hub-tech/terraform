##########################################################################################################################
# Outputs You can define output values to expose data about the resources you create.
##########################################################################################################################

# This output value exposes your EC2 instance's hostname from your Terraform workspace.

output "instance_hostname" {
  description = "Private DNS name of the EC2 instance."
  value       = aws_instance.web_server.private_dns
}

# This output value exposes the ID of the example security group.

output "security_group_id" {
  description = "ID of the example security group."
  value       = aws_security_group.example_sg.id
}

# This output value exposes the ARN of the DynamoDB table.

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table."
  value       = aws_dynamodb_table.my_table.arn
}

# This output value exposes the name of the DynamoDB table.

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table."
  value       = aws_dynamodb_table.my_table.name
}

# This output value exposes the ID of the VPC.

output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}


# Terraform prints out your output values when you run a plan or apply, and also stores them in your workspace's state file.