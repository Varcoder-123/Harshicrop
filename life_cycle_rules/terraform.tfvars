instance_count = 1
monitoring = true
associate_public_ips = true
cidr_blocks = ["172.31.0.0/20","172.31.64.0/20","172.31.32.0/20","172.31.48.0/20"]
instance_type = ["t2.micro","t2.large","t3.small","t3.medium"]
region = ["us-east-1","us-east-2","us-east-3"]
tags = {
  Environment = "dev"
  Project     = "ecommerce"
  Owner       = "vignesh"
}
ingress = [ 12, 23, "tcp" ]
config = {
  ami = "ami-0c421724a94bba6d6"
  key_name = "Hashicrop"
  vpc_security_group_ids = ["sg-0c2c1c476b1ffca8a"]
}