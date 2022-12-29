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

# resource "aws_internet_gateway_attachment" "igw_attach" {
#   vpc_id              = aws_vpc.VPC_GeC_IDC.id
#   internet_gateway_id = aws_internet_gateway.VPC_GeC_IDC_IGW
# }

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

#
resource "aws_route" "IDCRout_1" {
  route_table_id         = aws_route_table.VPC_GeC_IDC_RT.id
  destination_cidr_block = var.IDCRout_1
  gateway_id             = aws_internet_gateway.VPC_GeC_IDC_IGW.id
  depends_on             = [var.rt_id]
}

# cgw route
resource "aws_route" "IDCRout_2" {
  route_table_id         = aws_route_table.VPC_GeC_IDC_RT.id
  destination_cidr_block = var.IDCRout_2
  instance_id            = aws_instance.IDC_Gec_CGW.id
  depends_on             = [var.instance_cgw_id]
}

# 라우트 테이블 서브넷 연결
resource "aws_route_table_association" "IDCSubnetRTAssociation" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.VPC_GeC_IDC_RT.id
}

# 서브넷
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.VPC_GeC_IDC.id
  cidr_block              = var.subnet
  availability_zone       = var.subnet_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.tag_name}_subnet"
  }
}

# 인스턴스
# Create a instance cgw
resource "aws_instance" "IDC_Gec_CGW" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.instance_key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = file("${var.instance_file_cgw}")
  tags = {
    Name = "${var.instance_name}-CGW"
  }
}

resource "aws_instance" "IDC_Gec_DB" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.instance_key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = file("${var.instance_file_db}")
  tags = {
    Name = "${var.instance_name}-DB"
  }
}

resource "aws_instance" "IDC_Gec_DNS" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.instance_key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = file("${var.instance_file_dns}")
  tags = {
    Name = "${var.instance_name}-DNS"
  }
}

#보안그룹
resource "aws_security_group" "sg" {
  description = "aws_security_group"
  name        = var.security_group_name
  vpc_id      = aws_vpc.VPC_GeC_IDC.id
}

# 보안그룹 룰s
resource "aws_security_group_rule" "allow_sever_http_inbound" {
  type              = var.security_group_rule_type
  security_group_id = aws_security_group.sg.id

  from_port   = "8080"
  to_port     = "8080"
  protocol    = var.sg_protocol_tcp
  cidr_blocks = [var.sg_cidr_blocks]
}
resource "aws_security_group_rule" "allow_sever_ssh_inbound" {
  type              = var.security_group_rule_type
  security_group_id = aws_security_group.sg.id

  from_port   = "22"
  to_port     = "22"
  protocol    = var.sg_protocol_tcp
  cidr_blocks = [var.sg_cidr_blocks]
}
resource "aws_security_group_rule" "allow_sever_icmp_inbound" {
  type              = var.security_group_rule_type
  security_group_id = aws_security_group.sg.id

  from_port   = "-1"
  to_port     = "-1"
  protocol    = var.sg_protocol_tcp
  cidr_blocks = [var.sg_cidr_blocks]
}
resource "aws_security_group_rule" "allow_sever_dns_tcp_inbound" {
  type              = var.security_group_rule_type
  security_group_id = aws_security_group.sg.id

  from_port   = "53"
  to_port     = "53"
  protocol    = var.sg_protocol_tcp
  cidr_blocks = [var.sg_cidr_blocks]
}
resource "aws_security_group_rule" "allow_sever_dns_udp_inbound" {
  type              = var.security_group_rule_type
  security_group_id = aws_security_group.sg.id

  from_port   = "53"
  to_port     = "53"
  protocol    = var.sg_protocol_udp
  cidr_blocks = [var.sg_cidr_blocks]
}
resource "aws_security_group_rule" "allow_sever_https_inbound" {
  type              = var.security_group_rule_type
  security_group_id = aws_security_group.sg.id

  from_port   = "443"
  to_port     = "443"
  protocol    = var.sg_protocol_tcp
  cidr_blocks = [var.sg_cidr_blocks]
}
resource "aws_security_group_rule" "allow_sever_outbound" {
  type              = var.security_group_rule_type_1
  security_group_id = aws_security_group.sg.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = [var.sg_cidr_blocks]
}


# eni
resource "aws_network_interface" "test" {
  subnet_id         = aws_subnet.subnet.id
  private_ips       = [var.private_ips]
  security_groups   = [aws_security_group.sg.id]
  source_dest_check = false

  attachment {
    instance     = aws_instance.IDC_Gec_CGW.id
    device_index = 1
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.IDC_Gec_CGW.id
  vpc      = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.IDC_Gec_CGW.id
  allocation_id = aws_eip.lb.id
}
