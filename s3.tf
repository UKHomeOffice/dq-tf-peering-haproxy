variable "haproxy_bucket_name" {}
variable "region" {}

resource "aws_s3_bucket" "HAProxy_Bucketname" {
  bucket = "${var.haproxy_bucket_name}"
  acl    = "private"
  region   = "${var.region}"

  tags {
    Name = "HAProxy config bucket"
  }
}
