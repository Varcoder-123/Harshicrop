resource "aws_s3_bucket" "bucket" { # By default s3 bucket will be private
  bucket = var.bucket_name
}

resource "aws_cloudfront_origin_access_control" "origin_access_control" { # origin access control act as an authentication layer between cloudfront and s3 bucket
  name = var.origin_access_control
  description = "Example policy"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_s3_bucket_policy" "allow_cloud_front_policy" { # This policy is attached to s3 bucket , so that only cloud front can access it
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Allow",
      "Principal": {
        "AWS": "cloudfront.amazonaws.com"
      },
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::vicky1867123/*"
    }
  ]
})
}

resource "aws_s3_object" "object" { # Uploading the files to bucket
  for_each = fileset("./www","*")
  bucket = aws_s3_bucket.bucket.id
  key = each.value
  source = "./www/${each.value}"
  etag = filemd5("./www/${each.value}") # Terraform does NOT automatically detect file content changes , so this is needed
  content_type = lookup(
    {
      html = "text/html"
      css  = "text/css"
      js   = "application/javascript"
      png  = "image/png"
      jpg  = "image/jpeg"
      jpeg = "image/jpeg"
      gif  = "image/gif"
      svg  = "image/svg+xml"
      json = "application/json"
      txt  = "text/plain"
    },
    element(split(".",each.value), length(split(".",each.value)) - 1),
    "application/octet-stream" #Used if extension not found
  )
}


