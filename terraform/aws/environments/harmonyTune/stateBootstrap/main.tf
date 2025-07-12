module "s3" {
  source      = "./modules/s3"
  bucket_name = "${loval.env}-terraform-state-lock-tonegawa"
}

module "dynamo-db" {
  source = "../../../modules/dynamo-db"

  env          = local.env
  table_name   = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  tags = {
    name = "SessionID"
    type = "N"
  }
}
