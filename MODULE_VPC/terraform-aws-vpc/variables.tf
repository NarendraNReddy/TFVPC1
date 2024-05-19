#Project name variables
variable "Project_name" {
    type=string
}

variable "Environment" {
  type = string
}

variable "common_tags" {
  type=map 
}


#VPC variables 

#cidr_block       = "10.0.0.0/16"
variable "vpc_cidr" {
    type = string 
    
}

#enable_dns_hostnames = true
variable "enable_dns_hostnames" {
  default = true
}

variable "vpc_tags" {
    type = map 
    default = {}  
}

#IG2
variable "igw_tags" {
  type=map 
  default = {}
}

#Public subnet
variable "public_subnet_tags" {
  default = {}
}

#public subnet cidrs
variable "public_subnet_cidrs" {
  type = list 
  validation {
    condition = length(var.public_subnet_cidrs) == 2
    error_message = "Please enter two valid public subnet cidrs"
  }
}

#private subnet cidrs
variable "private_subnet_cidrs" {
  type = list 
  validation {
    condition = length(var.private_subnet_cidrs) == 2
    error_message = "Please enter two valid private subnet cidrs"
  }
}

variable "private_subnet_tags" {
  default = {}
}

#database subnet cidrs
variable "database_subnet_cidrs" {
  type = list 
  validation {
    condition = length(var.database_subnet_cidrs) == 2
    error_message = "Please enter two valid database subnet cidrs"
  }
}

variable "database_subnet_tags" {
  default = {}
}

#Route Table
variable "aws_nat_gateway_tags" {
  default = {}
}

# public_route_tags
variable "public_route_table_tags" {
  default = {}
}

# private_route_tags
variable "private_route_table_tags" {
  default = {}
}

# database_route_tags
variable "database_route_table_tags" {
  default = {}
}