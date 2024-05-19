
module "vpc" {
  source = "../terraform-aws-vpc"
  Project_name = var.Project_name
  Environment = var.Environment
  common_tags = var.common_tags
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  
}