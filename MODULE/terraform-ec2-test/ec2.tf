module "ec2_test" {
  source="../terraform-aws-ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  tags=var.tags 

}