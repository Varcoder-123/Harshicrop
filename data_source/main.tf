provider "aws" {
  region = var.region[0]
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet" "shared" {
  filter {
    name = "tag:Name"
    values = [ "subnet-us-east-1a" ]
  }
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

data "aws_ami" "ami_image" {
  owners = [ "amazon" ]
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name = "state"
    values = ["available"]
  }
}
resource "aws_instance" "Instance" {
  ami                = data.aws_ami.ami_image.id
  instance_type      = var.tags.Environment == "dev" ? "t2.micro" : "t3.micro" #conditional expression
  key_name           = var.config.key_name
  subnet_id = data.aws_subnet.shared.id
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

# resource "aws_security_group" "Security-group" {
#   name = "Custom security group"
#   description = "Allow SSH and HTTP"

#   dynamic ingress {           #Dynamic blocks
#     for_each = var.ingress_rules
#     content {
#       from_port = ingress.value.from_port
#       to_port = ingress.value.to_port
#       protocol = ingress.value.protocol
#       cidr_blocks = ingress.value.cidr_blocks
#     }
#   }

#   egress {
#     description = "Allow all outbound"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = tolist(var.cidr_blocks)
#   }

#   tags = merge(var.tags,{
#     Name = "Custom security group"
#   })
# }

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

# resource "aws_s3_bucket" "initial-bucket" {
#   count = length(var.bucket_names)
#   bucket = var.bucket_names[count.index]

#   tags = var.tags

#   versioning {
#     enabled = false
#   }

#   lifecycle {
#     precondition {
#       condition = can(regex("^mycompany-dev-.*$", var.bucket_names[count.index]))
#       error_message = "Bucket name must start with 'mycompany-dev-'"
#     }
#   }
# }