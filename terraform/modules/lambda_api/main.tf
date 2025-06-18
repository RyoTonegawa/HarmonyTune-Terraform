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
