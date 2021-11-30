provider "aws" {
  region = "us-west-2"
}

variable "queue_names" {
  description = "Create these queues with the enviroment prefixed"
  type = list(string)
  default = [
      "testqueue1",
      "testqueue2"
  ]
}

module queue {
  source = "./modules/sqs_queues"

  for_each = toset(var.queue_names)

  name = each.key
}
