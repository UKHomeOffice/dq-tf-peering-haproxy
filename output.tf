output "haproxy_subnet_id" {
  value = "${aws_subnet.haproxy_subnet.id}"
}

output "iam_roles" {
  value = ["${aws_iam_role.haproxy_ec2_server_role.id}"]
}

output "haproxy_private_ip2" {
  value = "${var.haproxy_private_ip2}"
}
