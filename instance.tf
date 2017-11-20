# Instance in HAProxyVPC
resource "aws_instance" "HAProxyInstance" {
 ami           = "${var.haproxy_ami_id}"
 instance_type = "${var.haproxy_instance_class}"
 key_name = "${var.haproxy_key}"
 subnet_id = "${aws_subnet.HAProxyVPC-az1.id}"
 vpc_security_group_ids = ["${aws_security_group.HAProxyVPC-default.id}"]
 associate_public_ip_address = true
 iam_instance_profile = "${aws_iam_instance_profile.HAProxyServerInstanceProfile.name}"

 tags {
   Name = "HAProxyInstance"
 }
}
