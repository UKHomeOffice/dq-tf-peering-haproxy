resource "aws_iam_policy" "haproxy_bucket_policy" {
  name   = "haproxy_bucket_policy"
  policy = "${file("s3policy.json")}"
}

resource "aws_iam_role" "haproxy_ec2_server_role" {
  name               = "haproxy_ec2_server_role"
  assume_role_policy = "${file("s3assumerole.json")}"
}

resource "aws_iam_policy_attachment" "attachs3_bucket_policy" {
  name       = "attachs3_bucket_policy"
  roles      = ["${aws_iam_role.haproxy_ec2_server_role.name}"]
  policy_arn = "${aws_iam_policy.haproxy_bucket_policy.arn}"
}

resource "aws_iam_instance_profile" "haproxy_server_instance_profile" {
  name = "haproxy_server_instance_profile"
  role = "${aws_iam_role.haproxy_ec2_server_role.name}"
}
