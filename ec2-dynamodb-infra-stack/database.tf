resource "aws_dynamodb_table" "my_table" {
  name           = "my-table"
  billing_mode   = "PROVISIONED"
  hash_key       = "id"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "id"
    type = "N"
  }

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}