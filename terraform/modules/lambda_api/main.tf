resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = merge(
        var.common_tags,
        {
            Name = "${var.common_tags.Project}-vpc"
        }
    )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main
    tags = merge(
        var.common_tags,
        {
            Name = "${var.common_tags.Project}-igw"
        }
    )
}

# Subnets
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = merge(
    var.common_tags,
    {
        Name = "public-subnet"
    }
  )
}
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = merge(
    var.common_tags,
    {
        Name = "private-subnet"
    }
  )
}
# NAT Instance
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values =["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "nat_sg" {
  name = "nat-sg"
  description = "Allow outbound from private subnet"
  vpc_id = aws_vpc.main.id

  ingress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  egress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.common_tags
}
resource "aws_instance" "nat" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public.id
    associate_public_ip_address = true
    source_dest_check = false
    # security_group_tags is not expected here
    user_data = file("user_data.sh")
    tags = merge(
        var.common_tags,
        {Name = "nat-instance"}
    )
}

# Route Tables of Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = var.common_tags
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.public.id
}

# Route table of Private
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        # Unexpected attribute: An attribute named "instance_id" is not expected here
        # instance_id = aws_instance.nat.id
    }
    tags = var.common_tags
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_exec" {
    name = "lambda-exec-role"
    assume_role_policy = jsondecode({
        Version = "2012-10-17",
        Statement = [{
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {Service = "lambda.amazonaws.com"}
        }]
    })
    tags = var.common_tags
}
resource "aws_iam_role_policy_attachment" "lambda_basic" {
    role = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  
}

resource "aws_lambda_function" "go_lambda" {
  function_name = "goLambdaWithSupabase"
  filename = "build/lambda.zip"
  handler = "main"
  runtime = "go1.x"
  role = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("build/lambda.zip")

  environment {
    variables = {
      SUPABASE_URL = var.supabase_url
      SUPABASE_API_KEY = var.supabase_api_key
    }
    }
  vpc_config {
    subnet_ids = [aws_subnet.private.id]
    security_group_ids = [aws_security_group.nat_sg.id]
  }
  tags = var.common_tags
}

# API Gateway
resource "aws_apigatewayv2_api" "lambda_api" {
  name = "go-api"
  protocol_type = "HTTP"
  tags = var.common_tags
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.lambda_api.id
  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.go_lambda.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /"
  target = "integrations/${aws_apigatewayv2_integtration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "lamnda_stage" {
  api_id = aws_apigatewayv2_api.lambda_api.id
  name = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "apigw_invoke" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.go_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}