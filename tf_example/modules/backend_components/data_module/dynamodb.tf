resource "aws_dynamodb_table" "dynamodb_table" {
  name             = local.dynamodb_table_name
  hash_key         = var.dynamodb_attributes[0].name
  range_key        = var.dynamodb_attributes[1].name
  write_capacity   = var.dynamodb_write_capacity
  read_capacity    = var.dynamodb_read_capacity
  billing_mode     = var.dynamodb_billing_mode
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  dynamic "attribute" {
    for_each = var.dynamodb_attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }


  lifecycle {
    prevent_destroy = false #to be changed to true when deploying
  }
}