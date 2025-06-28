locals {
  bucket_name = "tf-state-${lower(var.project)}"
  table_name  = "tf-state-lock"
  tags = {
    Project   = var.project
    Env       = "bootstrap"
    ManagedBy = "Terraform"
  }
}

# S3バケット
