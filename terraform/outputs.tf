output "api_endpoint" {
    description = "API Gateway endpoint URL"
    value = module.lambda_api.api_endpoint
}