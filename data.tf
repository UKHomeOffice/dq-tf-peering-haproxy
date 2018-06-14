data "aws_ami" "dq-peering-haproxy" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "dq-peering-haproxy*",
    ]
  }

  owners = [
    "self",
  ]
}

data "aws_ami" "dq-peering-haproxy-189" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "dq-peering-haproxy_1.8.9*",
    ]
  }

  owners = [
    "self",
  ]
}
