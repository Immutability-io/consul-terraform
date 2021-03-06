variable "ami" {
}

variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "private_key" {
    description = "Path to the private key specified by key_name."
}

variable "gossip_encryption_key" {
    description = "Result of consul keygen."
}

variable "password_file" {
    description = "Result sudo htpasswd -c .htpasswd."
}

variable "bastion_public_ip" {
    description = "Bastion host IP."
}

variable "bastion_user" {
    description = "Bastion host user."
}

variable "associate_public_ip_address" {
    description = "Create public IP."
    default = false
}

variable "subnet_id" {
    description = "The Subnet to use for the consul cluster."
}

variable "root_certificate" {
    description = "The root certificate for the consul cluster."
}

variable "consul_certificate" {
    description = "The certificate use for the consul cluster."
}

variable "consul_key" {
    description = "The key to use for the consul cluster."
}

variable "vpc_id" {
    description = "The VPC to use for the consul cluster."
}

variable "vpc_cidr" {
}

variable "servers" {
    default = "3"
    description = "The number of Consul servers to launch."
}

variable "datacenter" {
    description = "Name of consul datacenter."
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tagName" {
    default = "consul-server"
    description = "Name tag for the servers"
}

variable "tagFinance" {
    description = "Finance tag for the servers"
}

variable "tagOwnerEmail" {
    description = "Email tag for the servers"
}

variable "tagSchedule" {
    default = "AlwaysUp"
    description = "Schedule tag for the servers"
}

variable "tagBusinessJustification" {
    default = "Short lived instance that will auto terminate"
    description = "BusinessJustification tag for the servers"
}

variable "tagAutoStart" {
    default = "Off"
    description = "AutoStart tag for the servers"
}
