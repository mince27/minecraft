variable "ami" {
  default = {
    # debian-jessie-amd64-hvm-2017-01-15-1221-ebs
    us-east-2 = "ami-b2795cd7"
  }
  type = "map"
}

variable "availability_zones" {
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
  description = "Availability zones that the instances can be launched in"
  type        = "list"
}

variable "instance_type" {
  description = "The EC2 instrance type."
  default     = "t2.medium"
}

variable "key_name" {
  default     = "minecraft"
  description = "Key pair for SSH access."
}

variable "minecraft_port" {
  default     = 25565
  description = "The port that will be opened to allow Minecraft connections.  This should match the value in server.properties"
}

variable "name" {
  description = "Name to be applied to all the AWS resources"
  default     = "minecraft"
}

variable "region" {
  default = "us-east-2"
}

variable "s3_bucket" {
  description = "The S3 bucket where the instance will look for the server and create backups to"
  default = "mince27-mc"
}

variable "scheduled_shutdown" {
  description = "Cron expression for server instance shutdown"
  # Server is UTC so 3:40 = 10:40PM CDT
  # Coordinate this with the cronjob in user_data that stops minecraft
  default     = "40 3 * * *"
}

variable "scheduled_startup" {
  description = "Cron expression for server instance startup"
  # Server is UTC so 23:45 = 06:45PM CDT
  default = "45 23 * * *"
}

variable "subnet_ids" {
  default     = ["subnet-e3cd318a", "subnet-ccd6c2b4", "subnet-f59eabbf"]
  description = "Subnets the server can be launched in.  There should be a subnet corresponding to each availability zone"
  type        = "list"
}
