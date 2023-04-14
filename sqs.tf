resource "aws_sqs_queue" "terraform_queue" {
  name                        = "${local.env}-${local.chat_server_resource}-sqs"
  fifo_queue                  = true
  visibility_timeout_seconds  = 30
  message_retention_seconds   = 345600 # 4 days in seconds
  max_message_size            = 262144
  receive_wait_time_seconds   = 0
  delay_seconds               = 0
  content_based_deduplication = true # Required for high throughput FIFO queues
  sqs_managed_sse_enabled     = true
}
