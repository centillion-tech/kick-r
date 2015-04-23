output "address" {
    value = "${aws_instance.r-instance.public_dns}"
}
