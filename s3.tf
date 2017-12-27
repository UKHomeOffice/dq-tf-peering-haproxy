resource "random_string" "bucket_string" {
  length  = 4
  upper   = false
  number  = false
  special = false
  lower   = true
}

resource "aws_kms_key" "haproxy_config_bucket_key" {
  description             = "This key is used to encrypt Haproxy config bucket objects"
  deletion_window_in_days = 7

  tags = {
    Name             = "s3-${var.service}-config-kms-key-${var.environment}"
    Service          = "${var.service}"
    Environment      = "${var.environment}"
    EnvironmentGroup = "${var.environment_group}"
  }
}

resource "aws_s3_bucket" "haproxy_config_bucket" {
  bucket = "${var.s3_bucket_name}-${random_string.bucket_string.result}"
  acl    = "${var.s3_bucket_acl}"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.haproxy_config_bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${var.archive_s3_bucket}"
    target_prefix = "${var.service}-log/"
  }

  tags = {
    Name             = "s3-${var.service}-config-bucket-${var.environment}"
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

resource "aws_vpc_endpoint" "log_s3_endpoint" {
  vpc_id          = "${var.peeringvpc_id}"
  route_table_ids = ["${var.route_table_id}"]
  service_name    = "com.amazonaws.eu-west-2.s3"
}
