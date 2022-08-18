package test

import (
  "testing"
  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/stretchr/testify/assert"
)

// Standard Go test, with the "Test" prefix and accepting the *testing.T struct.

func TestAssetsBackend(t *testing.T) {
	t.Parallel()
	awsRegion := "eu-central-1"
	DyTable := "testing-assets-table-tf"
	Account_id := "444600356670"
	Sqs_name := "terraform-example-queue"
	iam_role := "assets_api_backend_testrole"
	lambda_name := "assets_api_backend_test"


	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/sandbox",

	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	  // Get the API arn so we can query AWS
	  APIArn := terraform.Output(t, terraformOptions, "api_gateway_arn")
	  APIId := terraform.Output(t, terraformOptions, "api_gateway_id")
	  APIArnExpected := "arn:aws:apigateway:" + awsRegion + ":" + ":/restapis/" + APIId

	  assert.Equal(t, APIArn, APIArnExpected)

	  // Get the SQS arn so we can query AWS
	  SQSArn := terraform.Output(t, terraformOptions, "assets_sqs_arn")
	  SQSArnExpected := "arn:aws:sqs:" + awsRegion + ":" + Account_id+ ":" + Sqs_name

	  assert.Equal(t, SQSArn, SQSArnExpected)

	  // Get the Dynamo arn so we can query AWS
	  DyArn := terraform.Output(t, terraformOptions, "dynamo_arn")
	  DyArnExpected := "arn:aws:dynamodb:" + awsRegion + ":" + Account_id + ":table/" +DyTable

	  assert.Equal(t, DyArn, DyArnExpected)

	  // Get the IAM Role arn so we can query AWS
	  IamArn := terraform.Output(t, terraformOptions, "iam_lambda_arn")
	  IamArnExpected := "arn:aws:iam:"  + ":" + Account_id + ":role/servicerole/" + iam_role

	  assert.Equal(t, IamArn, IamArnExpected)


	  // Get the Lambda arn so we can query AWS
	  LambdaArn := terraform.Output(t, terraformOptions, "lambda_function_arn")
	  LambdaArnExpected := "arn:aws:lambda:" + awsRegion + ":" + Account_id + ":function:" + lambda_name

	  assert.Equal(t, LambdaArn, LambdaArnExpected)
	  

}