module "ec2_test2" {
  source = "../terraform-aws-ec2"
   ami_id = var.ami_id
   instance_type = var.instance_type
   vpc_security_group_ids=["sg-035bd444d13fbad2f"]

   tags = {
    Name = "ec2-instance"
  }
}