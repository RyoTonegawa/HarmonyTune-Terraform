

resource "aws_dynamodb_table" "tf_lock" {
  name         = "tf_state-lock"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    name = var.tags.name
    type = var.tags.type
  }
}
