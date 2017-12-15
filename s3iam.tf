#*********************************
#* Setup S3 policy
#*********************************
resource "aws_iam_policy" "HAProxyBucketPolicy" {
  name        = "HAProxyBucketPolicy"
  policy      = "${file("s3policy.json")}"
}

#*********************************
#* Setup EC2 role for S3
#*********************************
resource "aws_iam_role" "HAProxyECServer2Role" {
  name               = "HAProxyECServer2Role"
  assume_role_policy = "${file("s3assume.json")}"
}

#*********************************
# Attach policy to role
#*********************************
resource "aws_iam_policy_attachment" "attachS3_bucket_policy" {
  name       = "attachS3_bucket_policy"
  roles      = ["${aws_iam_role.HAProxyECServer2Role.name}"]
  policy_arn = "${aws_iam_policy.HAProxyBucketPolicy.arn}"
}

#*********************************
#* Create instance profile for EC2
#*********************************
resource "aws_iam_instance_profile" "HAProxyServerInstanceProfile" {
  name  = "HAProxyServerInstanceProfile"
  role = "${aws_iam_role.HAProxyECServer2Role.name}"
}
