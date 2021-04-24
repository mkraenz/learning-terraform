output "user_name" {
  description = "The AWS IAM user name"
  value       = aws_iam_user.my_test_user.name
}

output "user_arn" {
  description = "The AWS IAM user ARN"
  value       = aws_iam_user.my_test_user.arn
}

output "user_uid" {
  description = "The AWS IAM user ARN"
  value       = aws_iam_user.my_test_user.unique_id
}
