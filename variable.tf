variable "haproxy_bucket_name" {}
variable "peeringvpc_id" {}
variable "haproxy_ip" {}
variable "haproxy_subnet_cidr_block" {}

variable "name_prefix" {
  default = "dq-"
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
