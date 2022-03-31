output "bucket_name" {
  value       = aws_s3_bucket.s3_bucket.bucket
  description = "Bucket name is"
}

output "backet_tags" {
  value = aws_s3_bucket.s3_bucket.tags_all
}

output "flugel_ec2_instance_id" {
  description = "Instance ID is:"
  value       = aws_instance.flugel_ec2_instance.id
}

output "flugel_ec2_instance_public_ip" {
  description = "Public IP is:"
  value       = aws_instance.flugel_ec2_instance.public_ip
}

output "flugel_ec2_instance_tags" {
  value = aws_instance.flugel_ec2_instance.tags_all
}

output "flugel_task2_instances_public_ip" {
  value = [
    for i, ec2 in aws_instance.flugel_task2_ec2_instance : {
      name : "flugel_task2_ec2_instance-${format("%01d", i + 1)}"
      public_ip : ec2.public_ip
    }
  ]
}

output "public_ip" {
  value = zipmap(aws_instance.flugel_task2_ec2_instance.*.id, aws_eip.eip.*.public_ip)
}