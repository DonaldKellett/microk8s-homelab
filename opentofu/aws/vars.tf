variable "email" {
  type = string
}

variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "ap-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "ssh_pubkey_path" {
  type    = string
  default = "~/.ssh/microk8s-homelab.pub"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
