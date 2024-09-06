# create a bucket for the static website - domain

resource "aws_s3_bucket" "static_website" {
  bucket = "${var.project_id}-${var.stack}-s3-bucket-01"

  tags = {
    Name = "Static Website Bucket"
  }
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "static_website" {
  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.static_website.arn}"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.static_website.arn}/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.static_website.arn]
    }
  }

}

resource "aws_s3_bucket_policy" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.static_website.json
}

