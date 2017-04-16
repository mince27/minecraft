provider "aws" {
  region = "${var.region}"
}

variable "ami" {
  default = {
    # debian-jessie-amd64-hvm-2017-01-15-1221-ebs
    us-east-2 = "ami-b2795cd7"
  }
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  default = "minecraft"
}

variable "minecraft_port" {
  default = 25565
}

variable "region" {
  default = "us-east-2"
}

variable "s3_bucket" {
  default = "mince27-mc"
}

variable "stack_name" {
  default = "minecraft"
}

###############################################

resource "aws_security_group" "minecraft" {
  name = "minecraft_sg"
  description = "Allow inbound SSH and minecraft traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "${var.minecraft_port}"
    to_port     = "${var.minecraft_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "minecraft" {
  name = "minecraft_server_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "minecraft" {
  name = "minecraft_server_policy"
  role = "${aws_iam_role.minecraft.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:List*",
        "s3:Put*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.s3_bucket}/*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "minecraft" {
  name  = "minecraft_server_profile"
  roles = ["${aws_iam_role.minecraft.name}"]
}

resource "aws_instance" "minecraft" {
  ami                         = "${lookup(var.ami, var.region)}"
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.minecraft.name}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.minecraft.name}"]
  user_data                   = "${data.template_file.userdata.rendered}"

  tags {
     Name = "${var.stack_name}"
  }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/scripts/user_data")}"

  vars {
    region = "${var.region}"
    s3_bucket = "${var.s3_bucket}"
  }
}

output "ip_address" {
  value = "${aws_instance.minecraft.public_ip}"
}
