terraform {
  required_providers {
    aws = {
      # 2.x 버전의 AWS 공급자 허용
      version = "~> 2.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# vpc 생성
resource "aws_vpc" "VPC_GeC_IDC" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "VPC_${var.tag_name}"
  }
}

# IGW
resource "aws_internet_gateway" "VPC_GeC_IDC_IGW" {
  vpc_id = aws_vpc.VPC_GeC_IDC.id
  tags = {
    Name = "IGW_${var.tag_name}"
  }
}

# 라우트 테이블
resource "aws_route_table" "VPC_GeC_IDC_RT" {
  vpc_id = aws_vpc.VPC_GeC_IDC.id
  route {
    cidr_block = var.rt_cidr
    gateway_id = aws_internet_gateway.VPC_GeC_IDC_IGW.id
  }
  tags = {
    Name = "VPC_${var.tag_name}_RT"
  }
}
