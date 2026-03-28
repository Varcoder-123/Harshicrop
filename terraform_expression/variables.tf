variable "instance_count" {
  description = "No of instances"
  type = number
}

variable "monitoring" {
  description = "Enabled detailed monitoring of Ec2 instances"
  type = bool
}

variable "associate_public_ips" {
  description = "public ips"
  type = bool
}

variable "cidr_blocks" {
  description = "custom security rule"
  type = set(string)
}

variable "instance_type" {
  description = "Type of the instance"
  type = list(string)
}

variable "region" {
  description = "Location"
  type = list(string)
}

variable "tags" {
  description = "tags"
  type = map(string)
}

variable "ingress" {
  description = "ingress value"
  type = tuple([number,number,string])
}

variable "config" {
  type = object({
    ami = string,
    key_name = string,
    vpc_security_group_ids = set(string)
  })
}

variable "bucket_names" {
  description = "List of buckets"
  type = list(string)
}

variable "template" {
  type = object({
    name_prefix = string,
    image_id = string,
    instance_type = string,
    key_name = string,
    vpc_security_group_ids = set(string)
  })
}

variable "autoscaling" {
  type = object({
    desired_capacity = number,
    max_size = number,
    min_size = number,
  })
}