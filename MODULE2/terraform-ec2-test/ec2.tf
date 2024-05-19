module "ec2_test" {
  source="../terraform-aws-ec2"
  instance_type = "t3.small"
  tags={
    Name="module_test"
    Terraform=true
  }
}