###############################################
provider "aws" {
  region = "${var.region}"
}

###############################################
data "template_file" "userdata" {
  template = "${file("${path.module}/scripts/user_data")}"

  vars {
    region = "${var.region}"
    s3_bucket = "${var.s3_bucket}"
  }
}

###############################################
resource "aws_security_group" "minecraft" {
  name = "minecraft_sg"
  description = "Allow inbound SSH and minecraft traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
  role  = "${aws_iam_role.minecraft.name}"
}

resource "aws_elb" "minecraft" {
  name            = "${var.name}"
  internal        = false
  security_groups = ["${aws_security_group.minecraft.id}"]
  subnets         = ["${var.subnet_ids}",]

  listener {
    instance_port     = "${var.minecraft_port}"
    instance_protocol = "tcp"
    lb_port           = "${var.minecraft_port}"
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = "22"
    instance_protocol = "tcp"
    lb_port           = "22"
    lb_protocol       = "tcp"
  }

  tags {
    Name = "${var.name}"
  }
}

resource "aws_launch_configuration" "minecraft" {
  name_prefix          = "${var.name}"
  iam_instance_profile = "${aws_iam_instance_profile.minecraft.name}"
  image_id             = "${lookup(var.ami, var.region)}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = ["${aws_security_group.minecraft.id}"]
  user_data            = "${data.template_file.userdata.rendered}"
}

resource "aws_autoscaling_group" "minecraft" {
  name                      = "${var.name}"
  availability_zones        = ["${var.availability_zones}"]
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.minecraft.name}"
  load_balancers            = ["${aws_elb.minecraft.id}"]
  vpc_zone_identifier       = ["${var.subnet_ids}"]
  wait_for_elb_capacity     = false
  desired_capacity          = 0
  min_size                  = 0
  max_size                  = 0

  tag {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_schedule" "minecraft-shutdown" {
  autoscaling_group_name = "${aws_autoscaling_group.minecraft.name}"
  recurrence             = "${var.scheduled_shutdown}"
  scheduled_action_name  = "mc-shutdown"
  desired_capacity       = 0
  min_size               = 0
  max_size               = 0
}

resource "aws_autoscaling_schedule" "minecraft-startup" {
  autoscaling_group_name = "${aws_autoscaling_group.minecraft.name}"
  recurrence             = "${var.scheduled_startup}"
  scheduled_action_name  = "mc-startup"
  desired_capacity       = 1
  min_size               = 1
  max_size               = 1
}

###############################################
output "server_url" {
  value = "${aws_elb.minecraft.dns_name}"
}
