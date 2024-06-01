resource "aws_vpc" "default_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "default_vpc"
    developer   = "Bryan Solares"
    contact     = "solares.josue@outlook.com"
    environment = "dev"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.default_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name        = "public_subnet_1"
    developer   = "Bryan Solares"
    contact     = "solares.josue@outlook.com"
    environment = "dev"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.default_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name        = "public_subnet_2"
    developer   = "Bryan Solares"
    contact     = "solares.josue@outlook.com"
    environment = "dev"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.default_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name        = "private_subnet_1"
    developer   = "Bryan Solares"
    contact     = "solares.josue@outlook.com"
    environment = "dev"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.default_vpc.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name        = "private_subnet_2"
    developer   = "Bryan Solares"
    contact     = "solares.josue@outlook.com"
    environment = "dev"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default_vpc.id
  tags = {
    Name        = "internet_gateway"
    developer   = "Bryan Solares"
    contact     = "solares.josue@outlook.com"
    environment = "dev"
  }
}


resource "aws_route_table" "public_tr" {
  vpc_id = aws_vpc.default_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name        = "public_route_table"
    developer   = "Bryan Solares"
    contact     = "solares.josue@outlook.com"
    environment = "dev"
  }
}

resource "aws_route_table" "private_tr" {
  vpc_id = aws_vpc.default_vpc.id

  tags = {
    Name        = "private_route_table"
    developer   = "Bryan Solares"
    contact     = "solares.josue@outlook.com"
    environment = "dev"
  }
}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_tr.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_tr.id
}

resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_tr.id
}

resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_tr.id
}
