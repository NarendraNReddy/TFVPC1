#project and env .User has to provide 
variable "Project_name" {
    type=string 
  
}

variable "Environment" {
  type=string 
}

variable "common_tags" {
    type=map 
    
  
}


#VPC variables.
#cidr_block       = "10.0.0.0/16"
variable "vpc_cidr" {
  type = string 
  default = "10.0.0.0/16" #10.0.0.0/16
}

#enable_dns_hostnames = true
variable "enable_dns_hostnames" {
    type = bool 
    default = true
  
}

variable "vpc_tags" {
  type = map
  default = {}
}


#igw
variable "igw_tags" {
  type = map
  default = {}
}

#public subnet tags:
#var.public_subnet_tags

variable "public_subnet_tags" {
  type = map 
  default = {}
}


variable "public_subnet_cidrs" {
    type = list 
    validation {
      condition = length(var.public_subnet_cidrs) == 2 
      error_message = "Please enter valid public subnet cidrs"
    }
}
