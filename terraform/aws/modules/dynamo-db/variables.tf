variable "tags" {
  type = object({
    name = string
    type = string
  })
}

variable "env" {
  type = string
}

variable "table_name" {
  type = string
}

variable "billing_mode" {
  type = string
}

variable "hash_key" {
  type = string
}
