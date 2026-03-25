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