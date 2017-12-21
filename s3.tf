resource "aws_s3_bucket" "haproxy_config_bucket" {
  bucket = "${var.s3_bucket_name["config"]}"
  acl    = "${var.s3_bucket_acl["config"]}"
  region = "${var.region}"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.haproxy_log_bucket.id}"
    target_prefix = "${var.service}-haproxy-log/"
  }

  tags = {
    Name             = "s3-${var.service}-haproxy-config-bucket-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_s3_bucket" "haproxy_log_bucket" {
  bucket = "${var.s3_bucket_name["log"]}"
  acl    = "${var.s3_bucket_acl["log"]}"
  region = "${var.region}"

  tags = {
    Name             = "s3-${var.service}-haproxy-log-bucket-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_vpc_endpoint" "haproxy_config_s3_endpoint" {
  vpc_id          = "${var.peeringvpc_id}"
  route_table_ids = ["${var.route_table_id}"]
  service_name    = "com.amazonaws.eu-west-2.s3"
}

resource "aws_vpc_endpoint" "logs_s3_endpoint" {
  vpc_id          = "${var.peeringvpc_id}"
  route_table_ids = ["${var.route_table_id}"]
  service_name    = "com.amazonaws.eu-west-2.s3"
}
