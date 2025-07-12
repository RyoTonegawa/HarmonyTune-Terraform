variable "aws_region" {
  default     = "ap-northeast-1"
  type        = string
  description = "Region for remote state bucket and lock table"
}

variable "project" {
  default = "HarmonyTune"
  type    = string
}

variable "env" {
  type    = string
  default = "remote-state"
}

