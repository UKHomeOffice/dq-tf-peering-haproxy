/*********************************
* S3 Bucket creation for HAproxy
**********************************/

resource "aws_s3_bucket" "HAProxy_Bucketname" {
  bucket = "${var.haproxy_bucket_name}"
  acl    = "private"
  region   = "${var.region}"

  tags {
    Name = "HAProxy config bucket"
  }
}
