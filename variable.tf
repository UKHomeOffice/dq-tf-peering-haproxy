variable "peeringvpc_id" {}
variable "haproxy_private_ip" {}
variable "haproxy_subnet_cidr_block" {}

variable "route_table_id" {}

variable "region" {
  default = "eu-west-2"
}

variable "s3_bucket_name" {
  type = "map"
}

variable "s3_bucket_acl" {
  type = "map"
}

variable "s3_bucket_visibility" {
  default = "private"
}

variable "name_prefix" {
  default = "dq-peering-"
}

variable "service" {
  default     = "dq-peering-haproxy"
  description = "As per naming standards in AWS-DQ-Network-Routing 0.5 document"
}

variable "environment" {
  default     = "preprod"
  description = "As per naming standards in AWS-DQ-Network-Routing 0.5 document"
}

variable "environment_group" {
  default     = "dq-peering"
  description = "As per naming standards in AWS-DQ-Network-Routing 0.5 document"
}

variable "az" {
  default = "eu-west-2a"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "SGCIDRs" {
  description = "Ingress CIDR block for the HAProxy Security Group."
  type        = "list"
}
