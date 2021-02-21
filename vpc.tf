terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.20"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_vpc" "jenkins_vpc" {
  cidr_block = "192.168.8.0/22"
}

resource "aws_subnet" "jenkins_subnet" {
  vpc_id = aws_vpc.jenkins_vpc.id
  cidr_block = cidrsubnet(aws_vpc.jenkins_vpc.cidr_block, 6, 0)
}

resource "aws_internet_gateway" "cyan_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "bluey_igw"
  }
}

output "inspect_subnet" {
  value = aws_subnet.jenkins_subnet.cidr_block
}

resource "aws_route_table" "cyan_routes" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cyan_igw.id
  }

  tags = {
    Name = "cyan_routes"
  }
}

resource "aws_route_table_association" "aws_access" {
  subnet_id      = aws_subnet.jenkins_subnet.id
  route_table_id = aws_route_table.cyan_routes.id
}