variable "region" {
  description = "region"
  type        = string
}

variable "cidr_block" {
  description = "cidr"
  type        = string
}

variable "tag_name" {
  description = "The vpc name "
  type        = string
}

variable "rt_id" {
  description = "rt_cidr"
  type        = string
}

variable "rt_cidr" {
  description = "rt_cidr"
  type        = string
}

variable "subnet" {
  description = "subnet"
  type        = string
}

variable "subnet_zone" {
  description = "subnet_zone"
  type        = string
}

variable "IDCRout_1" {
  description = "subnet_zone"
  type        = string
}

variable "IDCRout_2" {
  description = "IDCRout_2"
  type        = string
}
# 보안그룹
variable "security_group_name" {
  description = "security_group_name"
  type        = string
}

variable "security_group_rule_type" {
  description = "security_group_name"
  type        = string
}
variable "security_group_rule_type_1" {
  description = "security_group_rule_type_1"
  type        = string
}

variable "sg_cidr_blocks" {
  description = "cidr_blocks"
  type        = string
}

variable "sg_protocol_udp" {
  description = "cidr_blocks"
  type        = string
}
variable "sg_protocol_tcp" {
  description = "cidr_blocks"
  type        = string
}

# 인스턴스
variable "instance_cgw_id" {
  description = "instance_name"
  type        = string
}
variable "instance_name" {
  description = "instance_name"
  type        = string
}
variable "instance_ami" {
  description = "instance_ami"
  type        = string
}
variable "instance_type" {
  description = "instance_type"
  type        = string
}
variable "instance_key_name" {
  description = "instance_key_name"
  type        = string
}
variable "instance_file_cgw" {
  description = "instance_file_cgw"
  type        = string
}
variable "instance_file_db" {
  description = "instance_file_db"
  type        = string
}
variable "instance_file_dns" {
  description = "instance_file_dns"
  type        = string
}

# eni
variable "private_ips" {
  description = "instance_file_dns"
  type        = string
}
