data "aws_ami" "dq-peering-haproxy" {
  most_recent = true

  filter {
    name = "name"

    values = [
      var.namespace == "prod" ? "dq-peering-haproxy 557*" : "dq-peering-haproxy 557*",
    ]
  }

  owners = [
    "self",
  ]
}

