resource "aws_cloudwatch_log_group" "this" {
  name              = var.name
  retention_in_days = var.retention_in_days

  tags = var.tags
}

output "arn" {
  value = aws_cloudwatch_log_group.this.arn
}

output "name" {
  value = aws_cloudwatch_log_group.this.name
}
