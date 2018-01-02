resource "aws_instance" "peeringhaproxy" {
  ami                    = "${data.aws_ami.dq-peering-haproxy.id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${aws_subnet.haproxy_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.haproxy.id}"]
  private_ip             = "${var.haproxy_private_ip}"
  user_data              = "${var.s3_bucket_name}"
  key_name               = "${var.key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.haproxy_server_instance_profile.id}"

  count = "${local.haproxy}"

  tags = {
    Name             = "ec2-${var.service}-rhel-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_security_group" "haproxy" {
  vpc_id = "${var.peeringvpc_id}"

  tags = {
    Name             = "sg-${var.service}-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
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
      "0.0.0.0/0",
    ]
  }
}
