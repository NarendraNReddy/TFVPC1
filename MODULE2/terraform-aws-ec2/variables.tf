variable "ami_id" {
  type = string 
  default="ami-090252cbe067a9e58"
}

variable "vpc_security_group_ids" {
    type=list 
    default = ["sg-035bd444d13fbad2f"]
  
}

variable "instance_type" {
  type = string 
  
}

variable "tags" {
    type = map 
    default={}
}