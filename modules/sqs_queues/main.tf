data "aws_region" "current" {}

resource "aws_sqs_queue" "base_queue" {
  
  name                        = var.name
  message_retention_seconds   = var.retention_period
  visibility_timeout_seconds  = var.visibility_timeout
  redrive_policy              = jsonencode({
                                    "deadLetterTargetArn" = aws_sqs_queue.deadletter_queue.arn,
                                    "maxReceiveCount" = var.receive_count
                                })
}

resource "aws_sqs_queue" "deadletter_queue" {
  name                        = "${var.name}-dlq"
  message_retention_seconds   = var.retention_period
  visibility_timeout_seconds  = var.visibility_timeout
}

resource "aws_iam_policy" "consume_policy" {
  name        = "SQS-${var.name}-${data.aws_region.current.name}-consume_policy"
  description = "Attach this policy to consumes of ${var.name} SQS queue"
  policy      = data.aws_iam_policy_document.consume_policy.json
}

data "aws_iam_policy_document" "consume_policy" {
  statement {
    actions = [
      "sqs:DeleteMessage",
      "sqs:ReceiveMessage"
    ]
    resources = [
      aws_sqs_queue.base_queue.arn,
      aws_sqs_queue.deadletter_queue.arn
    ]
  }
}


resource "aws_iam_policy" "write_policy" {
  name        = "SQS-${var.name}-${data.aws_region.current.name}-write"
  description = "Attach this policy to writes for ${var.name} SQS queue"
  policy      = data.aws_iam_policy_document.write_policy.json
}

data "aws_iam_policy_document" "write_policy" {
  statement {
    actions = [
      "sqs:SendMessage",
    ]
    resources = [
      aws_sqs_queue.base_queue.arn
    ]
  }
}

resource "aws_iam_role" "sqs_consume_roles" {
  name = "sqsconsumerole"

  assume_role_policy = jsonencode({
    "Version"   = "2012-10-17",
    "Statement" = [
      {
        "Effect"    = "Allow"
        "Action"    = "sts:AssumeRole"
        "Resource": "arn:aws:iam::*"
      }
    ]
  })
}

resource "aws_iam_role" "sqs_write_roles" {
  name = "sqswriterole"

  assume_role_policy = jsonencode({
    "Version"   = "2012-10-17",
    "Statement" = [
      {
        "Effect"    = "Allow"
        "Action"    = "sts:AssumeRole"
        "Resource": "arn:aws:iam::*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sqs_consume_role" {
  role       = aws_iam_role.sqs_consume_roles.name
  policy_arn = aws_iam_policy.consume_policy.arn
}

resource "aws_iam_role_policy_attachment" "sqs_write_roles" {
  role       = aws_iam_role.sqs_write_roles.name
  policy_arn = aws_iam_policy.write_policy.arn
}