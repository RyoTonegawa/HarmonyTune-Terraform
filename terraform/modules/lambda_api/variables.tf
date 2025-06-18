variable "region" {
    type = string
    description = "region of AWS"
}

variable "supabase_url" {
    type = string
    description = "project url of supabase"
}

variable "supabase_api_key" {
  type = string
  description = "api key of supabase api"
  sensitive = true
}

variable "common_tags" {
  type = map(string)
  description = "shared tags for Project,enviromnet and so on"
}