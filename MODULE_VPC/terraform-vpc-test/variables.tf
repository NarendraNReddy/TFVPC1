variable "Project_Name" {
  default = "expense"
}

# Environment = var.Environment 
#   tags=var.common_tags

variable "Environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project="expense"
    Environment="dev"
    Terraform="true"
  }
}


variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

#public subnet cidrs 
variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable "database_subnet_cidrs" {
  default = ["10.0.21.0/24","10.0.22.0/24"]
}

