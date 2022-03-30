package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/gruntwork-io/terratest/modules/aws"
)

func TestResourcesTags(t *testing.T) {
	t.Parallel()
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "../.",
	})

	// AWS Region
	awsRegion := "us-east-1"

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init". Fail the test if there are any errors.
	terraform.Init(t, terraformOptions)

	// Run "terraform plan"
	terraform.Plan(t, terraformOptions)

	// Run "terraform apply". Fail the test if there are any errors.
	terraform.Apply(t, terraformOptions)

	// Bucket checks
	bucketName := terraform.Output(t, terraformOptions, "bucket_name")

	// Get Bucket Tags
	bucketTags := aws.GetS3BucketTags(t, awsRegion, bucketName)

	// Check for the tags
	nameTag, containsNameTag := bucketTags["Name"]
	assert.True(t, containsNameTag)
	assert.Equal(t, "Flugel", nameTag)

	ownerTag, containsOwnerTag := bucketTags["Owner"]
	assert.True(t, containsOwnerTag)
	assert.Equal(t, "InfraTeam", ownerTag)


	// Flugel_EC2_Instace Tags Check
	instanceID := terraform.Output(t, terraformOptions, "flugel_ec2_instance_id")

	// Look up the tags for the given Instance ID
	instanceTags := aws.GetTagsForEc2Instance(t, awsRegion, instanceID)

	// Instance Tests
	instanceNameTag, instanceContainsNameTag := instanceTags["Name"]
	assert.True(t, instanceContainsNameTag)
	assert.Equal(t, "Flugel", instanceNameTag)

	instanceOwnerTag, instanceContainsOwnerTag := instanceTags["Owner"]
	assert.True(t, instanceContainsOwnerTag)
	assert.Equal(t, "InfraTeam", instanceOwnerTag)
}