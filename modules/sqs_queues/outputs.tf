output "base_queue_arn" {
  value = aws_sqs_queue.base_queue.arn
}

output "deadletter_queue_arn" {
  value = aws_sqs_queue.deadletter_queue.arn
}

output "consume_policy_arn" {
  value = aws_iam_policy.consume_policy.arn
}


output "write_policy_arn" {
  value = aws_iam_policy.write_policy.arn
}

output "sqs_write_arn" {
  value = aws_iam_role.sqs_write_roles.arn
}

output "sqs_consume_arn" {
  value = aws_iam_role.sqs_consume_roles.arn
}