# pylint: disable=missing-docstring, line-too-long, protected-access, E1101, C0202, E0602, W0109
import unittest
from runner import Runner


class TestE2E(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.snippet = """

            provider "aws" {
              region = "eu-west-2"
              skip_credentials_validation = true
              skip_get_ec2_platforms = true
            }

            module "haproxy-instance" {
              source = "./mymodule"

              providers = {
                aws = "aws"
              }
                haproxy_subnet_cidr_block = "1.2.3.0/24"
                peeringvpc_id          = "1234"
                haproxy_private_ip     = "1.2.3.4"
                name_prefix            = "dq-"
                SGCIDRs                = ["1.2.3.0/24"]
                az                     = "foo"
                route_table_id         = "1234"
                s3_bucket_name         = "abcd"
                s3_bucket_acl          = "abcd"
                log_archive_s3_bucket      = "abcd"
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_name_prefix_peeringhaproxy(self):
        self.assertEqual(self.result['haproxy-instance']["aws_instance.peeringhaproxy"]["tags.Name"], "ec2-dq-peering-haproxy-rhel-preprod")

    def test_name_sg_haproxy(self):
        self.assertEqual(self.result['haproxy-instance']["aws_security_group.haproxy"]["tags.Name"], "sg-dq-peering-haproxy-preprod")

    def test_name_config_kms(self):
        self.assertEqual(self.result['haproxy-instance']["aws_kms_key.haproxy_config_bucket_key"]["tags.Name"], "s3-dq-peering-haproxy-config-kms-key-preprod")

    def test_name_config_bucket_name(self):
        self.assertEqual(self.result['haproxy-instance']["aws_s3_bucket.haproxy_config_bucket"]["tags.Name"], "s3-dq-peering-haproxy-config-bucket-preprod")


if __name__ == '__main__':
    unittest.main()
