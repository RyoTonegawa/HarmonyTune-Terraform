locals {
  base_tags = {
    Application = "HarmonyTune"
    ManagedBy   = "Terraform"
  }

  env_tags = {
    Env   = "dev"
    Owner = "BackendTeam"
  }

  cost_tags = { # 必要な場合だけ merge する
    CostCenter = "CC-1234"
  }

  tags = merge(
    local.base_tags,
    local.env_tags,
    local.cost_tags # 省略も OK
  )

  env = "boot-strap"
}
