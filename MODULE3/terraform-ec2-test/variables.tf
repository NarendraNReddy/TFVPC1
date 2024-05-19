#   #ami = var.ami_id
#   ami=data.aws_ami.ami_id.id
#   instance_type = var.instance_type
#   vpc_security_group_ids=["sg-035bd444d13fbad2f"]

#    tags = {
#     Name = "ec2-instance"
#   }

variable "ami_id" {
  default = "ami-090252cbe067a9e58"
}

variable "instance_type" {
  default = "t3.small"
}

variable "vpc_security_group_ids" {
    type=list
  default = ["sg-035bd444d13fbad2f"]
}

variable "tags" {
  default = {
    Name="ec2-instance"
  }
}