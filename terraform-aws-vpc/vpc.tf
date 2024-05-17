#Resource names,variable names , output names are terraform 
#Name tags are user. AWS
#terraform _ ,user names -

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  enable_dns_hostnames = var.enable_dns_hostnames

  # tags = {
  #   Name = "main"
  # }

  tags=merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name=local.resource_name # Same name will be displayed in vpc name as expense-dev
    }
  )
}


#gateway .main means attached to vpc (same name main is used here)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
        Name=local.resource_name
    }
  )
}



resource "aws_subnet" "public" {
  count=length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  #cidr_block = "10.0.1.0/24"
  
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
      ##azs=slice("${data.aws_availability_zones.available.names}",0,2)
      Name="${local.resource_name}-public-${local.az_names[count.index]}"

  
    }
  )
  
}