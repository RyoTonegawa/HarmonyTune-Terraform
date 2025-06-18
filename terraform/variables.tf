variable "region" {
  type = string
  default = "ap-apnortheast-1"
}
variable "supabase_url" {
  type = string
}
variable "supabase_api_key" {
  type = string
  sensitive = true
}