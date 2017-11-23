# pylint: disable=missing-docstring, line-too-long, protected-access
import unittest
from runner import Runner


class TestE2E(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.snippet = """
            provider "aws" {
              region = "eu-west-2"
              profile = "foo"
              skip_credentials_validation = true
              skip_get_ec2_platforms = true
            }
            
            module "root_modules" {
              source = "./mymodule"
              
              haproxy_bucket_name = "foo"
              region = "ff"
              
              haproxy_ami_id = "foo"
              haproxy_instance_class = "fo"
              haproxy_key = "f"
              haproxy_subnet_id = "foo"
              haproxy_vpc_security_group_ids = "foo"
              haproxy_iam_instance_profile = "foo"
               
            }
            
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        print (self.result)
        self.assertEqual(self.result["destroy"], False)

    def test_s3_acl(self):
        self.assertEqual(self.result["root_modules"]["aws_s3_bucket.HAProxy_Bucketname"]["acl"], "private")

    def test_instance_ami(self):
        self.assertEqual(self.result["root_modules"]["aws_instance.HAProxyInstance"]["ami"], "foo")


if __name__ == '__main__':
    unittest.main()