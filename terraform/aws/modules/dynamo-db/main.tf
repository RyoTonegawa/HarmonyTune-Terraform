resource "aws_dynamodb_table" "state_lock" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  attribute {
    name = "LockID"
    type = "S"
  }

  # tags = var.tags
}
