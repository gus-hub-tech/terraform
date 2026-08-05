##############################################################################################################
# Here's the full setup — EC2 IAM role, instance profile, policy, and how it attaches to your instance:
###############################################################################################################

# Trust policy: allows EC2 to assume this role

resource "aws_iam_role" "app_role" {
  name = "my-app-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# DynamoDB permissions

resource "aws_iam_policy" "dynamodb_access" {
  name = "my-table-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = aws_dynamodb_table.my_table.arn
      }
    ]
  })
}

# Attach the policy to the role

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

# Instance profile wraps the role so EC2 can actually use it

resource "aws_iam_instance_profile" "app_profile" {
  name = "my-app-ec2-profile"
  role = aws_iam_role.app_role.name
}