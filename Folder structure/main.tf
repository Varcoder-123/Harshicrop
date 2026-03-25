provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "name" {
  count              = var.instance_count
  ami                = "ami-02dfbd4ff395f2a1b"
  instance_type      = "t2.micro"
  key_name           = "Hashicrop"
  vpc_security_group_ids = ["sg-0c2c1c476b1ffca8a"]   

  tags = {
    Name = "Terraform"    
  }

  root_block_device {   
    volume_size = 10
    volume_type = "gp3"
  }
}    