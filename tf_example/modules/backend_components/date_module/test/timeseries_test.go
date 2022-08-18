package test

import (
  "testing"
  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/stretchr/testify/assert"
)

// Standard Go test, with the "Test" prefix and accepting the *testing.T struct.

func TestTerraformTimeseries(t *testing.T) {
	t.Parallel()
	awsRegion := "eu-central-1"
	APIGateway := "restapis"
	Account_id := "444600356670"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/sandbox",

	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	  // Get the ARN of the API so we can query AWS

	  APIArn := terraform.Output(t, terraformOptions, "api_gateway_arn")
	  APIId := terraform.Output(t, terraformOptions, "api_gateway_id")
	  APIArnExpected := "arn:aws:apigateway:" + awsRegion + "::/" + APIGateway + "/" + APIId

	  assert.Equal(t, APIArn, APIArnExpected)

	  // Get the ARN of the IAM Role writter for timestream table so we can query the AWS 

	  LbIamRoleArn := terraform.Output(t, terraformOptions, "iam_lambda_arn")
	  LbIamRoleArnExpected := "arn:aws:iam::" + Account_id + ":role/service-role/" 

	  assert.Contains(t, LbIamRoleArn, LbIamRoleArnExpected)

	  // Get the ARN of the Deployment so we can query the AWS 

	  APIDeployArn := terraform.Output(t, terraformOptions, "api_gateway_deploy_arn")
	  APIDeployArnExpected := "arn:aws:execute-api:" + awsRegion + ":" + Account_id + ":" + APIId +"/"

	  assert.Equal(t, APIDeployArn, APIDeployArnExpected)

	  // Get the ARN of the Stage so we can query the AWS 

	  APIStageArn := terraform.Output(t, terraformOptions, "api_gateway_stage_arn")
	  APIStageArnExpected := "arn:aws:apigateway:" + awsRegion + "::/" + APIGateway + "/" + APIId + "/stages/test"

	  assert.Equal(t, APIStageArn, APIStageArnExpected)
	
	  // Get the ARN of the Lambda Function so we can query the AWS 

	  LambdaArn := terraform.Output(t, terraformOptions, "lambda_function_arn")
	  LambdaArnExpected := "arn:aws:lambda:" + awsRegion + ":" + Account_id + ":function:Test-Authorizer"

	  assert.Equal(t, LambdaArn, LambdaArnExpected)
}