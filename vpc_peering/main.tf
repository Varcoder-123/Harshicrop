resource "aws_vpc" "primary_vpc" {
  cidr_block = var.primary_cidr_vpc
  provider = aws.primary
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_vpc" "secondary_vpc" {
  cidr_block = var.secondary_cidr_vpc
  provider = aws.secondary
  enable_dns_hostnames = true
  enable_dns_support = true
}
#################### Initially we are creating VPC's #######################################


resource "aws_subnet" "primary_subnet" {
  provider = aws.primary
  vpc_id = aws_vpc.primary_vpc.id
  cidr_block = var.primary_cidr_subnet
  availability_zone = data.aws_availability_zones.primary_zone_data.names[0]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "secondary_subnet" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary_vpc.id
  cidr_block = var.secondary_cidr_subnet
  availability_zone = data.aws_availability_zones.secondary_zone_data.names[0]
  map_public_ip_on_launch = true
}
################ Subnets ###############################


resource "aws_vpc_peering_connection" "peering" {
  provider = aws.primary
  vpc_id = aws_vpc.primary_vpc.id
  peer_vpc_id = aws_vpc.secondary_vpc.id
  peer_region = var.secondary
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "accept" {
  provider = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept = true
}
################## peering & accepter ######################

resource "aws_route_table" "primary_route" {
  provider = aws.primary
  vpc_id = aws_vpc.primary_vpc.id

  route {
    cidr_block = var.secondary_cidr_vpc
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }
}

resource "aws_route_table" "secondary_route" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary_vpc.id

  route {
    cidr_block = var.primary_cidr_vpc
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }
}
################## a routing rule set for your VPC. #########################

resource "aws_route_table_association" "primary_assoc" {
  provider = aws.primary
  subnet_id = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.primary_route.id
}

resource "aws_route_table_association" "secondaty_assoc" {
  provider = aws.secondary
  subnet_id = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.secondary_route.id
}
################# Defines WHICH subnet uses that route table #######################
resource "aws_security_group" "primary_sg" {
  provider = aws.primary
  vpc_id = aws_vpc.primary_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.secondary_cidr_vpc]
  }
  
  ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  # or your IP for better security
 }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "secondary_sg" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.primary_cidr_vpc]
  }
  
  ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  # or your IP for better security
 }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "primary_instance" {
  provider = aws.primary
  ami = data.aws_ami.primary_ami.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.primary_subnet.id
  vpc_security_group_ids = [ aws_security_group.primary_sg.id ]
  key_name = var.key_name
}

 resource "aws_instance" "secondary_instance" {
  provider = aws.secondary
  ami = data.aws_ami.secondary_ami.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.secondary_subnet.id
  vpc_security_group_ids = [ aws_security_group.secondary_sg.id ]
  key_name = var.key_name
}