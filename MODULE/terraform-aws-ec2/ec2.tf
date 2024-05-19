resource "aws_instance" "expense" {
  #ami = var.ami_id
  ami=data.aws_ami.ami_id.id
  instance_type = var.instance_type
  vpc_security_group_ids=["sg-035bd444d13fbad2f"]

   tags = {
    Name = "ec2-instance"
  }

}
# resource "aws_security_group" "allow_ssh_test" {
#   name        = "allow_ssh_test"
#   description = "Allow SSH inbound traffic and all outbound traffic"
  

#    ingress {
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]

#   }

#    egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "allow_SSH_test"
#     CreatedBy="NNR"
#   }
# }