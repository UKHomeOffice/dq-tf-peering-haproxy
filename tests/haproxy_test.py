# pylint: disable=missing-docstring, line-too-long, protected-access
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
                haproxy_subnet_id      = "1234"
                peeringvpc_id          = "1234"
                haproxy_bucket_name    = "haproxyconfigbucket"
                name_prefix            = "dq-"
                region                 = "eu-west-2"
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_name_prefix_haproxy(self):
        self.assertEqual(self.result['haproxy-instance']["aws_instance.peeringhaproxy"]["tags.Name"], "t2-micro")

    def test_name_prefix_peeringhaproxy(self):
        self.assertEqual(self.result['haproxy-instance']["aws_instance.peeringhaproxy"]["tags.Name"], "dq-haproxy-ec2")

    def test_name_prefix_haproxy(self):
        self.assertEqual(self.result['haproxy-instance']["aws_security_group.haproxy"]["tags.Name"], "dq-haproxy-sg")

    def test_name_prefix_haproxy_bucketname(self):
        self.assertEqual(self.result['haproxy-instance']["aws_s3_bucket.haproxy_bucketname"]["tags.Name"], "dq-haproxy-s3-bucket")

if __name__ == '__main__':
    unittest.main()
