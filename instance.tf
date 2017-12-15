variable "haproxy_ami_id" {}
variable "haproxy_instance_class" {}
variable "haproxy_key" {}
variable "haproxy_subnet_id" {}
variable "haproxy_vpc_security_group_ids" {}
variable "haproxy_iam_instance_profile" {}

# Instance in HAProxyVPC
resource "aws_instance" "HAProxyInstance" {
 ami           = "${var.haproxy_ami_id}"
 instance_type = "${var.haproxy_instance_class}"
 key_name = "${var.haproxy_key}"
 subnet_id = "${var.haproxy_subnet_id}"
 vpc_security_group_ids = ["${var.haproxy_vpc_security_group_ids}"]
 associate_public_ip_address = true
 iam_instance_profile = "${var.haproxy_iam_instance_profile}"

 tags {
   Name = "HAProxyInstance"
 }
}
