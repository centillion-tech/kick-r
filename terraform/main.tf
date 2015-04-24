# Specify the provider and access details
provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

# Public subnets

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "10.0.0.0/24"
    availability_zone = "${var.aws_region}b"
}

# Routing table for public subnets

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}

# R-instance

resource "aws_security_group" "default" {
    name = "terraform_r_instance"
    description = "Used in the terraform"

    # SSH access from anywhere
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTP access from anywhere
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"
}

resource "aws_instance" "r-instance" {
    # The connection block tells our provisioner how to
    # communicate with the resource (instance)
    connection {
        # The default username for our AMI
        user = "ubuntu"

        # The path to your keyfile
        key_file = "${var.key_path}"
    }

    ami = "${var.aws_ami}"
    availability_zone = "${var.aws_region}b"
    instance_type = "m3.2xlarge"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.default.id}"]
    subnet_id = "${aws_subnet.public.id}"
}

resource "aws_eip" "r-instance" {
    instance = "${aws_instance.r-instance.id}"
    vpc = true
}
