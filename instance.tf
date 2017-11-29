variable "haproxy_bucket_name" {}
variable "name_prefix" {}
variable "region" {}

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

resource "aws_instance" "PeeringHAProxy" {
  ami                    = "${data.aws_ami.dq-peering-haproxy.id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${module.peering.PeeringSubnet2}"
  vpc_security_group_ids = ["${aws_security_group.HAProxy.id}"]

  tags {
    Name = "${local.name_prefix}ec2"
  }
}

resource "aws_security_group" "HAProxy" {
  vpc_id = "${aws_vpc.peeringvpc.id}"

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

resource "aws_s3_bucket" "HAProxy_Bucketname" {
  bucket = "${var.haproxy_bucket_name}"
  acl    = "private"
  region   = "${var.region}"

  tags {
    Name = "${local.name_prefix}s3-bucket"
  }
}
