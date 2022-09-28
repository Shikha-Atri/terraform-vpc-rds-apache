variable "AWS_REGION" {    
    default = "ap-south-1"
}
variable "vpc_name" {
  description = "The name of the VPC."
  default     = "Terraform VPC"
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  default     = "10.0.0.0/16"
}

variable "vpc_instance_tenancy" {
  default     = "default"
  description = "Tenancy of instances"
}

variable "public_subnet_name" {
  description = "The name of the Public subnet."
  default     = "pub-subnet"
}

variable "public_subnet_cidr_block" {
  description = "The CIDR block of the public subnet."
  default     = "10.0.0.0/24"
}

variable "public_subnet_AZ" {
  description = "AZ of public subnet."
  default     = "ap-south-1a"
}

variable "private_subnet_name" {
  description = "The name of the private subnet."
  #type        = list(string)
  default     = "pri-subnet"
  #default     = ["pri-subnet0","pri-subnet1"]
}

#variable "private_subnet1_name" {
  #description = "The name of the private subnet."
 # default     = "pri1-subnet"
#}


variable "private_subnet_cidr_block" {
  description = "The CIDR block of the private subnet."
  type        = list(string)
  default     = ["10.0.1.0/24","10.0.2.0/24"]
}

#variable "private_subnet1_cidr_block" {
 # description = "The CIDR block of the private subnet."
  #default     = "10.0.2.0/24"
#}

variable "private_subnet_AZ" {
  description = "AZ of private subnet."
  type        = list(string)
  default     = ["ap-south-1b","ap-south-1c"] 
}

variable "IG_name" {
  description = "The name of internet gateway."
  default     = "my_gw"
}

variable "eip_name" {
  description = "The name of elastic IP."
  default     = "my_eip"
}

variable "NAT_GATEWAY" {
  description = "The name of nat gateway."
  default     = "my_nat"
}

variable "SG1" {
  description = "The name of security group."
  default     = "Pub_Security_Group"
}

variable "SG2" {
  description = "The name of security group."
  default     = "Pri_Security_Group"
}


variable "public_instance_name" {
  description = "instance name"
  default     = "public-instance"
}

variable "ami_id" {
  description = "The ID of ami."
  default     = "ami-076e3a557efe1aa9c"
}

variable "instance_type" {
 description = "instance type"
  default     = "t2.micro"
}

variable "db_instance_name" {
  description = "instance name"
  default     = "DB-instance"
}
variable "db_password" {
  description = "instance name"
  default     = "qwerty123"
}
variable "key_pair" {
  description = "key pair name"
  default     = "MY"
}