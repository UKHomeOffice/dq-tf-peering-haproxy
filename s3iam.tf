
resource "aws_iam_policy" "HAProxyBucketPolicy" {
  name        = "HAProxyBucketPolicy"
  policy      = "${file("s3policy.json")}"
}

resource "aws_iam_role" "HAProxyECServer2Role" {
  name               = "HAProxyECServer2Role"
  assume_role_policy = "${file("s3assumerole.json")}"
}

resource "aws_iam_policy_attachment" "attachS3_bucket_policy" {
  name       = "attachS3_bucket_policy"
  roles      = ["${aws_iam_role.HAProxyECServer2Role.name}"]
  policy_arn = "${aws_iam_policy.HAProxyBucketPolicy.arn}"
}

resource "aws_iam_instance_profile" "HAProxyServerInstanceProfile" {
  name  = "HAProxyServerInstanceProfile"
  role = "${aws_iam_role.HAProxyECServer2Role.name}"
}
