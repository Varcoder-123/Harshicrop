resource "aws_s3_bucket" "bucket" { # By default s3 bucket will be private
  bucket = var.bucket_name
}

resource "aws_cloudfront_origin_access_control" "oac" { # origin access control act as an authentication layer between cloudfront and s3 bucket
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

resource "aws_cloudfront_distribution" "name" { # Cloud front 
   enabled             = true
   default_root_object = "index.html" #When user hits https://your-domain/ CloudFront serves: indec.html
  
  origin { #origin where content is stored
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name #Cloud front will fetch content from s3
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id #secure access to s3
    origin_id = "s3-origin"
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin" #Connects to origin block
    viewer_protocol_policy = "redirect-to-https" #HTTP → automatically redirect to HTTPS

    allowed_methods = ["GET", "HEAD"] 
    cached_methods  = ["GET", "HEAD"] # read request allowed

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

 viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}


