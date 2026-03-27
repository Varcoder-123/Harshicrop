resource "aws_instance" "Instance" {
  count              = var.instance_count
  ami                = var.config.ami
  instance_type      = var.instance_type[0]
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

resource "aws_s3_bucket" "initial-bucket" {
  count = length(var.bucket_names)
  bucket = var.bucket_names[count.index]

  tags = var.tags

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_launch_template" "template" {
 name_prefix = var.template.name_prefix
 image_id = var.template.image_id
 instance_type = var.template.instance_type
 key_name = var.template.key_name
 vpc_security_group_ids = [  ]
}