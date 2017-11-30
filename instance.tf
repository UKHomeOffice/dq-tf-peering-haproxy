variable "haproxy_bucket_name" {}
variable "haproxy_subnet_id" {}
variable "peeringvpc_id" {}
variable "name_prefix" {}

locals {
  name_prefix = "${var.name_prefix}haproxy-"
}

variable instance_type {
  default = "t2.micro"
}

data "aws_ami" "dq-peering-haproxy" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "dq-peering-haproxy*",
    ]
  }

  owners = [
    "093401982388",
  ]
}

resource "aws_instance" "peeringhaproxy" {
  ami                    = "${data.aws_ami.dq-peering-haproxy.id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.haproxy_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.haproxy.id}"]

  tags {
    Name = "${local.name_prefix}ec2"
  }
}

resource "aws_security_group" "haproxy" {
  vpc_id = "${var.peeringvpc_id}"

  tags {
    Name = "${local.name_prefix}sg"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "haproxy_bucketname" {
  bucket = "${var.haproxy_bucket_name}"
  acl    = "private"
  region = "eu-west-2"

  tags {
    Name = "${local.name_prefix}s3-bucket"
  }
}
