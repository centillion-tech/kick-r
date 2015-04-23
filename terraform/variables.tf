variable "key_name" {
    description = "Name of the SSH keypair to use in AWS."
}

variable "key_path" {
    description = "Path to the private portion of the SSH key specified."
}

variable "aws_region" {
    description = "AWS region to launch servers."
    default = "ap-northeast-1"
}

variable "aws_ami" {
    description = "AMI name"
}
