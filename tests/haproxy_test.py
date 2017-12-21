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
                s3_bucket_name = {
                    config = "abcd"
                    log = "abcd"
                }

                s3_bucket_acl = {
                    config = "private"
                    log = "log-delivery-write"
                }
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_name_prefix_peeringhaproxy(self):
        self.assertEqual(self.result['haproxy-instance']["aws_instance.peeringhaproxy"]["tags.Name"], "ec2-dq-peering-haproxy-rhel-preprod")

    def test_name_sg_haproxy(self):
        self.assertEqual(self.result['haproxy-instance']["aws_security_group.haproxy"]["tags.Name"], "sg-dq-peering-haproxy-preprod")

if __name__ == '__main__':
    unittest.main()
