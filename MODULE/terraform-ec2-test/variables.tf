variable "ami_id" {
  default = "ami-090252cbe067a9e58"
}

variable "instance_type" {
    default = "t3.micro"
  
}

variable "vpc_security_group_ids" {
    type = list
    default = ["sg-035bd444d13fbad2f"]
}

variable "tags" {
  default = {
    Name="ec2_instance"
  }
}
