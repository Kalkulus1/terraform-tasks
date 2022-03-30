output "bucket_name" {
  value       = aws_s3_bucket.s3_bucket.bucket
  description = "Bucket name is"
}

output "flugel_ec2_instance_arn" {
  description = "arn is:"
  value       = aws_instance.flugel_ec2_instance.arn
}

output "flugel_ec2_instance_public_ip" {
  description = "Public IP is:"
  value       = aws_instance.flugel_ec2_instance.public_ip
}