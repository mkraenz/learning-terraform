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
  bucket = "tfdeletemetestbucket"
  acl    = "private"

  tags = {
    Name = "deleteme_test_bucket"
    Test = "delete me via terraform"
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
    "Resource": "${aws_s3_bucket.deleteme_test_bucket.arn}"
  }
}
EOF
}

output "access_key_id" {
  value = aws_iam_access_key.test_access_key.id
}


# Copy to clipboard via
# tf show -json | jq .values.outputs.access_key_secret.value | tr -d '"' | xclip -selection clipboard
output "access_key_secret" {
  value     = aws_iam_access_key.test_access_key.secret
  sensitive = true
}

