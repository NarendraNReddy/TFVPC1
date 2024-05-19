#   #ami = var.ami_id
#   ami=data.aws_ami.ami_id.id
#   instance_type = var.instance_type
#   vpc_security_group_ids=["sg-035bd444d13fbad2f"]

#    tags = {
#     Name = "ec2-instance"
#   }

variable "ami_id" {
  type = string 
}

variable "instance_type" {
  type=string 
}

variable "vpc_security_group_ids" {
    type=list 
   
}

variable "tags" {
    type=map 

}