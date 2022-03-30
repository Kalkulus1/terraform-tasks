variable "aws_access_key" {
  description = "AWS Access Key"
}
variable "aws_secret_key" {
  description = "AWS Secret Access Key"
}
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "(Required) Creates a unique bucket name"
  type        = string
  default     = "flugel-bucket-24453235245"
}

variable "force_destroy" {
  description = "(Optional) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = string
  default     = true
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    "Name" : "Flugel",
    "Owner" : "InfraTeam"
  }
}
