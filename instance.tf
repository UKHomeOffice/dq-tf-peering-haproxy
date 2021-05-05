resource "aws_iam_role_policy_attachment" "cloud_watch_agent" {
  role       = aws_iam_role.haproxy_ec2_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# module "ec2_alarms_peeringhaproxy" {
#   source          = "github.com/UKHomeOffice/dq-tf-cloudwatch-ec2"
#   naming_suffix   = local.naming_suffix
#   environment     = var.environment
#   pipeline_name   = "peeringhaproxy"
#   ec2_instance_id = aws_instance.peeringhaproxy[0].id
# }

resource "aws_instance" "peeringhaproxy" {
  ami                    = data.aws_ami.dq-peering-haproxy.id
  instance_type          = var.namespace == "prod" ? var.instance_type_prod : var.instance_type_notprod
  subnet_id              = aws_subnet.haproxy_subnet.id
  vpc_security_group_ids = [aws_security_group.haproxy.id]
  private_ip             = var.haproxy_private_ip
  user_data              = var.s3_bucket_name
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.haproxy_server_instance_profile.id

  user_data = <<EOF
#!/bin/bash

set -e

#log output from this user_data script
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

# start the cloud watch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -s -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
EOF

  lifecycle {
    prevent_destroy = true

    ignore_changes = [ami]
  }

  tags = {
    Name = "ec2-${local.naming_suffix}"
  }
}

# module "peeringhaproxy2" {
#   source          = "github.com/UKHomeOffice/dq-tf-cloudwatch-ec2"
#   naming_suffix   = local.naming_suffix
#   environment     = var.environment
#   pipeline_name   = "peeringhaproxy2"
#   ec2_instance_id = aws_instance.peeringhaproxy2[0].id
# }

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
