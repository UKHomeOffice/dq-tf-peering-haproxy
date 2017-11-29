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

            module "peering-haproxy" {
              source = "./mymodule"

              providers = {
                aws = "aws"
              }
                haproxy_bucket_name    = "testhaproxybucketname"
                name_prefix            = "dq-"
                region                 = "eu-west-2"
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_az(self):
        self.assertEqual(self.result['peering-haproxy']["aws_subnet.PeeringSubnet2"]["availability_zone"], "eu-west-2a")

    def test_name_prefix_PeeringHAProxy(self):
        self.assertEqual(self.result['peering-haproxy']["aws_instance.PeeringHAProxy"]["tags.Name"], "dq-haproxy-ec2")

    def test_name_prefix_HAProxy(self):
        self.assertEqual(self.result['peering-haproxy']["aws_security_group.HAProxy"]["tags.Name"], "dq-haproxy-sg")

    def test_name_prefix_HAProxy_Bucketname(self):
        self.assertEqual(self.result['peering-haproxy']["aws_s3_bucket.HAProxy_Bucketname"]["tags.Name"], "dq-haproxy-s3-bucket")    

if __name__ == '__main__':
    unittest.main()
