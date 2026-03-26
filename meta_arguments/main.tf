provider "aws" {
  region = var.region[0]
}

resource "aws_s3_bucket" "initial-bucket" {
  count = length(var.bucket_names)
  bucket = var.bucket_names[count.index]

  tags = var.tags
}

resource "aws_s3_bucket" "second-bucket" {
  for_each = var.second_bucket
  bucket = each.value

  tags = var.tags
}