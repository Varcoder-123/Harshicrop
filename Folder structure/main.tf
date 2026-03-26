provider "aws" {
  region = var.region[0]
}

resource "aws_instance" "Instance" {
  count              = var.instance_count
  ami                = var.config[0]
  instance_type      = var.instance_type[3]
  key_name           = var.config[1]
  vpc_security_group_ids = var.config[2]
  monitoring = var.monitoring
  associate_public_ip_address = var.associate_public_ips

  tags = merge(var.tags,{
    Name = "AWS instance"
  })

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
    from_port = var.ingress[0]
    to_port = var.ingress[1]
    protocol = var.ingress[2]
    cidr_blocks = tolist(var.cidr_blocks) //It allows ALL IPs in the list. Security group = rule-based (not order-based)
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = tolist(var.cidr_blocks)
  }

  tags = merge(var.tags,{
    Name = "Custom security group"
  })
}