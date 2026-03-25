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
  type = list(string)
}

variable "instance_type" {
  description = "Type of the instance"
  type = list(string)
}

variable "region" {
  description = "Location"
  type = list(string)
}