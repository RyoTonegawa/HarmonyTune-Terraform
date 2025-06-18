# グローバル変数定義

/**
    特定のクラウドプロバイダやサービスと連携に必要な
    設定を行う。
    リージョンやAWSプロファりうの設定を行う
*/
provider "aws" {
  region = var.region
}

locals {
  common_tags = {
    Project = "Harmony-Tune"
    Environment = terraform.workspace
    Owner = "Ryo"
    ManagedBy = "Terraform"
  }
}

module "lambda_api" {
  source = "./modules"
}