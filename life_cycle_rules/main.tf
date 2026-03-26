resource "aws_instance" "Instance" {
  count              = var.instance_count
  ami                = var.config.ami
  instance_type      = var.instance_type[3]
  key_name           = var.config.key_name
  vpc_security_group_ids = var.config.vpc_security_group_ids
  monitoring = var.monitoring
  associate_public_ip_address = var.associate_public_ips

  tags = merge(var.tags,{
    Name = "AWS instance"
  })

  root_block_device {   
    volume_size = 10
    volume_type = "gp3"
  }

  lifecycle {
   create_before_destroy = true
  }
}