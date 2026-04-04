data "aws_availability_zones" "primary_zone_data" {
  provider = aws.primary
  state = "available"
}

data "aws_availability_zones" "secondary_zone_data" {
  provider = aws.secondary
  state = "available"
}

data "aws_ami" "primary_ami" {
  provider = aws.primary
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

}

data "aws_ami" "secondary_ami" {
  provider = aws.secondary
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
}