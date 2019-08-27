// Provider vars

variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "us-east-1"
}

// Nomad instance vars

variable "nomad_instance_count" {
  default = "3"
}

variable "instance_role" {
  description = "Nomad instance type"
  default     = "server"
}

variable "public_key" {}

variable "aws_vpc_id" {}

variable "subnet_id" {}

variable "availability_zone" {}

variable "instance_type" {}

variable "ami" {
  description = "Ubuntu Xenial Nomad Server AMI in AWS us-east-1 region"
  default     = "ami-0ac8c1373dae0f3e5"
}

variable "icmp_cidr" {
  default = "0.0.0.0/0"
}

variable "ssh_cidr" {
  default = "0.0.0.0/0"
}

variable "nomad_cidr" {
  default = "0.0.0.0/0"
}

variable "role_name" {
  description = "Name for IAM role that allows Nomad cloud auto join"
  default     = "nomad-cloud-auto-join-aws"
}

variable "dc" {
  type        = string
  default     = "dc1"
  description = "Define the name of Nomad datacenter"
}

variable "nomad_region" {
  type        = string
  default     = "global"
  description = "Define the name of Nomad region"
}

variable "authoritative_region" {
  type        = string
  default     = "global"
  description = "Define the name of Nomad authoritative region"
}

variable "retry_join" {
  description = "Used by Nomad to automatically form a cluster."
  default     = "provider=aws tag_key=nomad-node tag_value=server"
}

variable "secure_gossip" {
  description = "Used by Nomad to enable gossip encryption"
  default     = "cg8StVXbQJ0gPvMd9o7yrg=="
}

// Cloudflare vars
variable "zone_name" {
  description = "The name of DNS domain, for example 'nomad.com'"
}

variable "domain_name" {
  description = "The name of subnomain, for example 'mynomad'"
}
