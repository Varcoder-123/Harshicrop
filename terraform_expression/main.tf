provider "aws" {
  region = var.region[0]
}

resource "aws_instance" "Instance" {
  count              = var.instance_count
  ami                = var.config.ami
  instance_type      = var.tags.Environment == "dev" ? "t2.micro" : "t3.micro"
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

# resource "aws_s3_bucket" "initial-bucket" {
#   count = length(var.bucket_names)
#   bucket = var.bucket_names[count.index]

#   tags = var.tags

#   lifecycle {
#     prevent_destroy = false
#   }
# }

# resource "aws_launch_template" "template" {
#  name_prefix = var.template.name_prefix
#  image_id = var.template.image_id
#  instance_type = var.template.instance_type
#  key_name = var.template.key_name
 
#  vpc_security_group_ids = var.template.vpc_security_group_ids
 
#  tags = merge(var.tags,{
#     Name = "launch-template"
#   })

#  tag_specifications {
#    resource_type = "instance" ##It tells AWS → WHICH resource to apply tags to
#    tags = var.tags ##tags are applied to EC2 instances created USING THE LAUNCH TEMPLATE 
#  }
# }

# resource "aws_autoscaling_group" "autoscaling" {
#   desired_capacity = var.autoscaling.desired_capacity
#   min_size = var.autoscaling.min_size
#   max_size = var.autoscaling.max_size

#   launch_template {
#     id = aws_launch_template.template.id
#     version = "$Latest"
#   }

#   availability_zones = [ "us-east-1a" ]

#   tag {
#     key                 = "Environment" ##✔ Tag applied to ASG
#     value               = "dev" ##✔ Tag ALSO applied to EC2 instances created by ASG. When propagate_at_launch = false ✔ Tag applied ONLY to ASG 
#     propagate_at_launch = true
#   }

#   lifecycle {
#     ignore_changes = [desired_capacity]
#   }
# }

# resource "aws_launch_template" "template" {
#  name_prefix = var.template.name_prefix
#  image_id = var.template.image_id
#  instance_type = var.template.instance_type
#  key_name = var.template.key_name
 
#  vpc_security_group_ids = var.template.vpc_security_group_ids
 
#  tags = merge(var.tags,{
#     Name = "launch-template"
#   })

#  tag_specifications {
#    resource_type = "instance" ##It tells AWS → WHICH resource to apply tags to
#    tags = var.tags ##tags are applied to EC2 instances created USING THE LAUNCH TEMPLATE 
#  }
# }

# resource "aws_autoscaling_group" "autoscaling" {
#   desired_capacity = var.autoscaling.desired_capacity
#   min_size = var.autoscaling.min_size
#   max_size = var.autoscaling.max_size

#   launch_template {
#     id = aws_launch_template.template.id
#     version = "$Latest"
#   }

#   availability_zones = [ "us-east-1a" ]

#   tag {
#     key                 = "Environment" ##✔ Tag applied to ASG
#     value               = "dev" ##✔ Tag ALSO applied to EC2 instances created by ASG. When propagate_at_launch = false ✔ Tag applied ONLY to ASG 
#     propagate_at_launch = true
#   }

#   lifecycle {
#     replace_triggered_by = [ aws_launch_template.template ]
#   }
# }

# resource "aws_s3_bucket" "initial-bucket" {
#   count = length(var.bucket_names)
#   bucket = var.bucket_names[count.index]

#   tags = var.tags

#   versioning {
#     enabled = false
#   }

#   lifecycle {
#     postcondition {
#       condition = self.versioning[0].enabled == true
#       error_message = "S3 bucket versioning is NOT enabled!"
#     }
#   }
# }

resource "aws_s3_bucket" "initial-bucket" {
  count = length(var.bucket_names)
  bucket = var.bucket_names[count.index]

  tags = var.tags

  versioning {
    enabled = false
  }

  lifecycle {
    precondition {
      condition = can(regex("^mycompany-dev-.*$", var.bucket_names[count.index]))
      error_message = "Bucket name must start with 'mycompany-dev-'"
    }
  }
}