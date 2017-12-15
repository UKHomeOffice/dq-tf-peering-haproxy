locals {
  name_prefix = "${var.name_prefix}haproxy-"
}

resource "aws_subnet" "haproxy_subnet" {
  vpc_id                  = "${var.peeringvpc_id}"
  cidr_block              = "${var.haproxy_subnet_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}haproxy-subnet"
  }
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
  subnet_id              = "${aws_subnet.haproxy_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.haproxy.id}"]
  private_ip             = "${var.haproxy_ip}"

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
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "${var.SGCIDRs}",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "${var.SGCIDRs}",
    ]
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
