terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "terraform-iam-playground"
}

resource "aws_iam_user" "my_test_user" {
  name = "my_test_user"
  path = "/deleteme/"
  tags = {
    Name = "Peter Jackson"
  }
}

resource "aws_iam_access_key" "test_access_key" {
  user = aws_iam_user.my_test_user.name
}

# resource "aws_iam_user_policy_attachment" "s3_full_access" {
#   user       = aws_iam_user.my_test_user.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }

resource "aws_s3_bucket" "deleteme_test_bucket" {
  bucket        = "tfdeletemetestbucket"
  acl           = "private"
  force_destroy = true

  tags = {
    Name = "deleteme_test_bucket"
    Test = "delete me via terraform"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3600
  }
}

resource "aws_s3_bucket_policy" "public_if_tagged" {
  bucket = aws_s3_bucket.deleteme_test_bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "${aws_s3_bucket.deleteme_test_bucket.arn}/*",
    "Principal": "*",
    "Condition": {
      "StringEquals": {
        "s3:ExistingObjectTag/public": "yes"
      }
    }
  }
}
EOF
}

resource "aws_s3_bucket_object" "test_file" {
  bucket = aws_s3_bucket.deleteme_test_bucket.id
  key    = "test.txt"
  source = "./test.txt"
  etag   = filemd5("./test.txt")
  tags = {
    "public" = "yes"
  }
}

resource "aws_iam_user_policy" "s3_test_bucket_access" {
  name   = "s3_test_bucket_access"
  user   = aws_iam_user.my_test_user.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "s3:*",
    "Resource": "${aws_s3_bucket.deleteme_test_bucket.arn}/*"
  }
}
EOF
}

output "access_key_id" {
  value = aws_iam_access_key.test_access_key.id
}

output "access_key_secret" {
  value     = aws_iam_access_key.test_access_key.secret
  sensitive = true
}
