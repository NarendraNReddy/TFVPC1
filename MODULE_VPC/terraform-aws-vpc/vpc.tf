resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr 
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
        Name=local.resource_name
    }
  )
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags =merge(
    var.common_tags,
    var.igw_tags,
        {
           Name=local.resource_name
        }
  )
  
}

#public subnet 
resource "aws_subnet" "public" { #public[0],public[1]
  count= length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
        Name="${local.resource_name}-public-${local.azs[count.index]}" #expense-public-us-east-1a
    }
  )
  
}

#private subnet
resource "aws_subnet" "private" { #private[0],private[1]
  count= length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]
 
  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
        Name="${local.resource_name}-private-${local.azs[count.index]}" #expense-private-us-east-1a
    }
  )
  
}

#database subnet
resource "aws_subnet" "database" {#database[0],database[1]
  count= length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]
  
  tags = merge(
    var.common_tags,
    var.database_subnet_tags,
    {
        Name="${local.resource_name}-database-${local.azs[count.index]}" #expense-private-us-east-1a
    }
  )
  
}


#Elastic IP 
resource "aws_eip" "nat" {
  domain   = "vpc"
}

#NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id #only one subnet i.e public is assigned to NAT. 

  tags = merge(
    var.common_tags,
    var.aws_nat_gateway_tags,
    {
        Name="${local.resource_name}"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw] #explicit dependency
}

# Route tables 
#public route table
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

#private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id


  tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {
        Name="${local.resource_name}-private"
    }
  )
}

#database route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id


  tags = merge(
    var.common_tags,
    var.database_route_table_tags,
    {
        Name="${local.resource_name}-database"
    }
  )
}

#public route
resource "aws_route" "pubic_route_igw" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

#private route
resource "aws_route" "private_route_nat" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

#private route
resource "aws_route" "database_route_nat" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}



#Route table association
resource "aws_route_table_association" "public" {
  count=length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public.id
}


#Route table association
resource "aws_route_table_association" "private" {
  count=length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private.id
}



#Route table association
resource "aws_route_table_association" "database" {
  count=length(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database.id
}







