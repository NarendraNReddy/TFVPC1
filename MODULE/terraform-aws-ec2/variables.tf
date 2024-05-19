variable "ami_id" {
  type = string 
}

variable "instance_type" {
    type = string 
    
}

variable "vpc_security_group_ids" {
    type = list
    
}

variable "tags" {
  type = map 
}