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
resource "aws_internet_gateway" "igw" {
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

#private 
resource "aws_subnet" "private" {
  count=length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  #cidr_block = "10.0.1.0/24"
  
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  

  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
      ##azs=slice("${data.aws_availability_zones.available.names}",0,2)
      Name="${local.resource_name}-private-${local.az_names[count.index]}"

  
    }
  )
  
}

#database 
resource "aws_subnet" "database" {
  count=length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  #cidr_block = "10.0.1.0/24"
  
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  

  tags = merge(
    var.common_tags,
    var.database_subnet_tags,
    {
      ##azs=slice("${data.aws_availability_zones.available.names}",0,2)
      Name="${local.resource_name}-private-${local.az_names[count.index]}"

  
    }
  )
  
}


#Elastic IP
resource "aws_eip" "nat" {
  domain   = "vpc"
}

#Nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id #two subnets with public[0],public[1]

  tags = merge(
    var.common_tags,
    var.nat_gateway_tags,
    {
      Name="${local.resource_name}" #expense-dev
    }
  )
  

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw] #explicity dependency. NAT to IGw.
}


# Route Tables:
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.public_route_table_tags,
    {
      Name="${local.resource_name}-public"
    }
  ) 
  
}



resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {
      Name="${local.resource_name}-private" # expense-dev-public
    }
  ) 
  
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.database_route_table_tags,
    {
      Name="${local.resource_name}-database" #expense-dev-database
    }
  ) 
  
}

#routes to public 
resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

#private route
resource "aws_route" "private_nat" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

#private route
resource "aws_route" "database_nat" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}


#association of prubli to routes
resource "aws_route_table_association" "public" {
  #2 public assocation 
  count=length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
  #2 public assocation 
  count=length(var.private_subnet_cidrs)
 subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private.id
}



resource "aws_route_table_association" "database" {
  #2 public assocation 
  count=length(var.database_subnet_cidrs)
   subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database.id
}


