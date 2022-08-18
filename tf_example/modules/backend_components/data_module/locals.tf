locals {
    lambda_function_name = "${var.env}-${var.lambda_function_name}"
    lambda_role =  "${var.env}-${var.lambda_role}"
    lambda_policy_name = "${var.env}-${var.lambda_policy_name}"
    api_name = "${var.env}-${var.api_name}"
    stage_name = "${var.env}-${var.stage_name}"
    dynamodb_table_name = "${var.env}-${var.dynamodb_table_name}"
}