locals {
  resource_name="${var.Project_name}-${var.Environment}"
  #azs="${data.aws_availability_zones.available.names}"
  az_names=slice("${data.aws_availability_zones.available.names}",0,2)
  
}
