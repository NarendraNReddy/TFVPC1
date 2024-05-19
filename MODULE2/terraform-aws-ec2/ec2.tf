resource "aws_instance" "expense" {
  #ami = var.ami_id
  ami=var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids=["sg-035bd444d13fbad2f"]

   tags = var.tags

}