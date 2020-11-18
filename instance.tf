resource "aws_instance" "peeringhaproxy" {
  ami                    = data.aws_ami.dq-peering-haproxy.id
  instance_type          = var.namespace == "prod" ? var.instance_type_prod : var.instance_type_notprod
  subnet_id              = aws_subnet.haproxy_subnet.id
  vpc_security_group_ids = [aws_security_group.haproxy.id]
  private_ip             = var.haproxy_private_ip
  user_data              = var.s3_bucket_name
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.haproxy_server_instance_profile.id

  lifecycle {
    prevent_destroy = true

    ignore_changes = [ami]
  }

  tags = {
    Name = "ec2-${local.naming_suffix}"
  }
}

resource "aws_instance" "peeringhaproxy2" {
  ami                    = data.aws_ami.dq-peering-haproxy.id
  instance_type          = var.namespace == "prod" ? var.instance_type_prod : var.instance_type_notprod
  subnet_id              = aws_subnet.haproxy_subnet.id
  vpc_security_group_ids = [aws_security_group.haproxy.id]
  private_ip             = var.haproxy_private_ip2
  user_data              = var.s3_bucket_name
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.haproxy_server_instance_profile.id

  lifecycle {
    prevent_destroy = true

    ignore_changes = [ami]
  }

  tags = {
    Name = "ec2-${local.naming_suffix}"
  }
}

resource "aws_security_group" "haproxy" {
  vpc_id = var.peeringvpc_id

  tags = {
    Name = "sg-${local.naming_suffix}"
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = var.SGCIDRs
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
