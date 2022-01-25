# ----------------------------------
# VPC : Single configuration
# Subnet : Horizontal scaling
# IGW : Temporary hold
# Route table : Temporary hold
# ----------------------------------

# Create the VPC
resource "aws_vpc" "archetype" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Archetype VPC"
  }
}

# Create the Subnet
resource "aws_subnet" "api_a" {
  vpc_id = "${aws_vpc.archetype.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "Public Subnet A"
  }
}
resource "aws_subnet" "api_b" {
  vpc_id = "${aws_vpc.archetype.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "Public Subnet B"
  }
}

# Create Intenet Gateway
resource "aws_internet_gateway" "archetype" {
  vpc_id = "${aws_vpc.archetype.id}"

  tags = {
    Name = "Prototype Internet Gateway"
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
  subnet_id = "${aws_subnet.api_a.id}"
  route_table_id = "${aws_route_table.archetype.id}"
}

resource "aws_route_table_association" "api_b" {
  subnet_id = "${aws_subnet.api_b.id}"
  route_table_id = "${aws_route_table.archetype.id}"
}
