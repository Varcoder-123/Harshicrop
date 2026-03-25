provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "Instance" {
  count              = var.instance_count
  ami                = "ami-02dfbd4ff395f2a1b"
  instance_type      = var.instance_type[3]
  key_name           = "Hashicrop"
  vpc_security_group_ids = ["sg-0c2c1c476b1ffca8a"]
  monitoring = var.monitoring
  associate_public_ip_address = var.associate_public_ips
  

  tags = {
    Name = "Terraform"    
  }

  root_block_device {   
    volume_size = 10
    volume_type = "gp3"
  }
}

resource "aws_security_group" "Security-group" {
  name = "Custom security group"
  description = "Allow SSH and HTTP"

  ingress {
    description = "Allow ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.cidr_blocks[1]]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_blocks[2]]
  }

  tags = {
    Name = "Custome Security group"
  }
}