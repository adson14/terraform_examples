resource "aws_vpc" "new-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.prefix}-nova-vpc"
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}
# output "az" {
#   value = data.aws_availability_zones.available.names
# }


resource "aws_subnet" "subnets" {
  count                   = 2
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.new-vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-subnet-${count.index}"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.new-vpc.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "new-rt" {
  vpc_id = aws_vpc.new-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.prefix}-rt"
  }

}

resource "aws_route_table_association" "new-rt-association" {
  count          = 2
  route_table_id = aws_route_table.new-rt.id
  subnet_id      = aws_subnet.subnets.*.id[count.index]
}


output "vpc_id" {
  value       = aws_vpc.new-vpc.id
  description = "ID da VPC criada"
}

output "private_subnet_ids" {
  value       = aws_subnet.subnets[*].id
  description = "IDs das subnets privadas"
}


