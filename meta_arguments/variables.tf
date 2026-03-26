variable "region" {
  description = "Location"
  type = list(string)
}

variable "bucket_names" {
  description = "List of buckets"
  type = list(string)
}

variable "tags" {
  type = map(string) 
}

variable "second_bucket" {
  type = set(string)
}