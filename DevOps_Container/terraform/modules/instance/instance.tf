# ----------------------------------
# VPC : Single configuration
# Subnet : Horizontal scaling
# IGW : Temporary hold
# Route table : Temporary hold
# ----------------------------------

# Create the VPC
resource "aws_vpc" "archetype" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Archetype VPC"
  }
}

# Create the public Subnet
resource "aws_subnet" "public_subnet_api_a" {
  vpc_id = "${aws_vpc.archetype.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "Public Subnet A"
  }
}
resource "aws_subnet" "public_subnet_api_b" {
  vpc_id = "${aws_vpc.archetype.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "Public Subnet B"
  }
}
# Create the private Subnet
resource "aws_subnet" "private_subnet_db_a" {
    vpc_id = "${aws_vpc.archetype.id}"
    cidr_block = "10.0.128.0/24"
    availability_zone = "ap-northeast-1a"
    tags = {
      Name = "private-db_a"
    }
}
resource "aws_subnet" "private_subnet_db_b" {
    vpc_id = "${aws_vpc.archetype.id}"
    cidr_block = "10.0.129.0/24"
    availability_zone = "ap-northeast-1c"
    tags = {
      Name = "private-db_b"
    }
}


# Create Intenet Gateway
resource "aws_internet_gateway" "archetype" {
  vpc_id = "${aws_vpc.archetype.id}"

  tags = {
    Name = "Archetype Internet Gateway"
  }
}

# Create Route table
resource "aws_route_table" "archetype" {
  vpc_id = "${aws_vpc.archetype.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.archetype.id}"
  }

  tags = {
    Name = "Archetype Route Table"
  }
}

# Atach Routing table to Subnet
resource "aws_route_table_association" "api_a" {
  subnet_id = "${aws_subnet.public_subnet_api_a.id}"
  route_table_id = "${aws_route_table.archetype.id}"
}

resource "aws_route_table_association" "api_b" {
  subnet_id = "${aws_subnet.public_subnet_api_b.id}"
  route_table_id = "${aws_route_table.archetype.id}"
}
