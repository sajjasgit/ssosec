variable "instance_type" {
  description = "WebServer EC2 instance type"
  type        = string
  validation {
    condition     = contains(["t1.micro", "t2.nano", "t2.micro", "t2.small", "t2.medium", "t2.large", "m1.small", "m1.medium", "m1.large", "m1.xlarge", "m2.xlarge", "m2.2xlarge", "m2.4xlarge", "m3.medium", "m3.large", "m3.xlarge", "m3.2xlarge", "m4.large", "m4.xlarge", "m4.2xlarge", "m4.4xlarge", "m4.10xlarge", "c1.medium", "c1.xlarge", "c3.large", "c3.xlarge", "c3.2xlarge", "c3.4xlarge", "c3.8xlarge", "c4.large", "c4.xlarge", "c4.2xlarge", "c4.4xlarge", "c4.8xlarge", "g2.2xlarge", "g2.8xlarge", "r3.large", "r3.xlarge", "r3.2xlarge", "r3.4xlarge", "r3.8xlarge", "i2.xlarge", "i2.2xlarge", "i2.4xlarge", "i2.8xlarge", "d2.xlarge", "d2.2xlarge", "d2.4xlarge", "d2.8xlarge", "hi1.4xlarge", "hs1.8xlarge", "cr1.8xlarge", "cc2.8xlarge", "cg1.4xlarge"], var.instance_type)
    error_message = "must be valid EC2 instance type"
  }
}

variable "keyname" {
  description = "Name of an existing EC2 KeyPair to enable SSH access to the instance"
}

variable "hostedzone" {
  description = "The DNS name of an existing Amazon Route 53 hosted zone"
  default     = "ssosec.com"
  type        = string
  validation {
    condition     = can(regex("(?!-)[a-zA-Z0-9-.]{1,63}(?<!-)", var.hostedzone))
    error_message = "must be a valid DNS zone name."
  }
}

variable "ssh_location" {
  description = "The IP address range that can be used to SSH to the EC2 instances"
  type        = string
  default     = "0.0.0.0/0"
  validation {
    condition     = can(regex("(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"), var.ssh_location)
    error_message = "must be a valid IP CIDR range of the form x.x.x.x/x."
  }
}

variable "app_name" {
  description = "name of the application"
  default     = "ssosec"
}

variable "env" {
  description = "environment where we are deploying application"
}

variable "vpc_cidr" {
  description = "vpc cidr block"
}

variable "public_subnet_cidr" {
  description = "the cidr block of public subnet 1"
}

variable "region" {
  description = "the region of application deployment"
}