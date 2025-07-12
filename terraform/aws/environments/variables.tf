variable "env" {
  description = "Environment code. Allowed: dev | stg | prd | bootstrap"
  type        = string

  validation {
    condition     = contains(["dev", "stg", "prd", "bootstrap"], var.env)
    error_message = "env must be one of dev, stg, prd, or bootstrap."
  }
}
