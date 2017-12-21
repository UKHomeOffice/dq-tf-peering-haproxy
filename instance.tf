resource "aws_instance" "peeringhaproxy" {
  ami                    = "${data.aws_ami.dq-peering-haproxy.id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${aws_subnet.haproxy_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.haproxy.id}"]
  private_ip             = "${var.haproxy_ip}"

  count = "${local.haproxy}"

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
