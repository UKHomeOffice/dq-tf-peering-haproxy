data "aws_ami" "dq-peering-haproxy" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "dq-peering-haproxy 465*",
    ]
  }

  owners = [
    "self",
  ]
}

