resource "aws_s3_bucket" "state_lock" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "state_lock" {
  bucket = aws_s3_bucket.state_lock.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_lock" {
  bucket = aws_s3_bucket.state_lock.id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
# ① S3 バケット（tfstate 保存用）
# terraform import aws_s3_bucket.terraform_state my-terraform-tfstate-bucket

# ② DynamoDB テーブル（state lock 用）
# terraform import aws_dynamodb_table.terraform_locks terraform-locks


# 既に bucket 本体は import 済みと仮定
# terraform import aws_s3_bucket_versioning.state_lock terraform-state-lock-tonegawa
# terraform import aws_s3_bucket_server_side_encryption_configuration.state_lock terraform-state-lock-tonegawa
