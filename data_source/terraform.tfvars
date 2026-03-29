instance_count = 2
monitoring = true
associate_public_ips = true
cidr_blocks = ["172.31.0.0/20","172.31.64.0/20","172.31.32.0/20","172.31.48.0/20"]
instance_type = ["t2.micro","t2.large","t3.small","t3.medium"]
region = ["us-east-1","us-east-2","us-east-3"]
tags = {
  Environment = "prod"
  Project     = "ecommerce"
  Owner       = "vignesh"
}
ingress = [ 12, 23, "tcp" ]
config = {
  ami = "ami-0c421724a94bba6d6"
  key_name = "Hashicrop"
  vpc_security_group_ids = ["sg-0c2c1c476b1ffca8a"]
}
bucket_names = [ "vicky18672345628", "karthik12034261746", "bhanuprakesh2345233728" ]
template = {
  name_prefix = "Harshicrop-terraform"
  image_id = "ami-0ec10929233384c7f"
  instance_type = "t3.medium"
  key_name = "Hashicrop"
  vpc_security_group_ids = [ "sg-0c2c1c476b1ffca8a" ]
}
autoscaling = {
  desired_capacity = 2
  max_size = 3
  min_size = 1
}
ingress_rules = [ 
{
  from_port = 12
  to_port = 23
  protocol = "tcp"
  cidr_blocks = ["172.31.0.0/20"]
},
{
  from_port = 24
  to_port = 22
  protocol = "udp"
  cidr_blocks = ["172.31.64.0/20"]
} ]

