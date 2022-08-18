package test

import (
  "testing"
  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/stretchr/testify/assert"
)

// Standard Go test, with the "Test" prefix and accepting the *testing.T struct.

func TestTerraformEcsService(t *testing.T) {
	t.Parallel()
	LbName := "test-lb"
	Target_gr := "ecs-fargate-cluster-test"


	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/sandbox",

		Vars: map[string]interface{} {
			//"AWS_REGION" : awsRegion,
		},

	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	  // Get the LB listener ARN so we can query AWS
	  LbListenerArn := terraform.Output(t, terraformOptions, "aws_lb_listener_arn")
	  LbListenerArnExp := LbName

	  assert.Contains(t, LbListenerArn, LbListenerArnExp)

	  // Get Target Group ARN so we can query AWS 

	  TargetGr := terraform.Output(t, terraformOptions, "aws_lb_target_group_arn")
	  TargetGrExp := Target_gr

	  assert.Contains(t, TargetGr, TargetGrExp)



}