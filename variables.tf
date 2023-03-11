# by D.sviridov

variable "aws_account_id" {
  default = "*yours id*"
}

variable "region" {
  default = "some aws region"
}

variable "zone_id" {
  default = "yours route53 zone ID"
}

# set instance type for your's need's
variable "instance_types" {
  default = "t2.micro"
}

#recive ENV from MAIN tf file 
variable "environment" {
  description = "environment"
  type        = string
}

#this code work 100% only on Ubuntu image.! in other's you will need to make some fixes
variable "ami_id" {
  default = "set aws ami-id. of UBUNTU "
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

###############################################################################
