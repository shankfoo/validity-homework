################################################################################
################################################################################
variable "pilot_inputs" {
  type = "map"
  description = <<TXT
    a map of all the human inputs required.
    declare these inputs in a separate tfvars file.
  TXT
}
################################################################################
variable "access_key" {
  description = <<TXT
    the aws access key that terraform should use.
    declare these inputs in a separate and secure tfvars file.
  TXT
}
variable "secret_key" {
  description = <<TXT
    the aws secret key that terraform should use.
    declare these inputs in a separate and secure tfvars file.
  TXT
}
################################################################################
variable "name_tag" {
  default = "validity-homework"
}
variable "aws_regions" {
  type          = "map"
  description   = "maps the pilot input 'site' to the aws region identifier."
  default       = {
    "Virginia"  = "us-east-1"
    "Ireland"   = "eu-west-1"
  }
}
variable "aws_fargate_cpu_units" {
  type = "map"
  description   = "maps the pilot input 'cpu' to the fargate cpu value."
  default       = {
    "0.25 vCPU" = "256"
    "0.5 vCPU"  = "512"
    "1 vCPU"    = "1024"
    "2 vCPU"    = "2048"
    "4 vCPU"    = "4096"
  }
}

variable "aws_fargate_ram_units" {
  type = "map"
  description = "maps the pilot input 'cpu' to the fargate cpu value."
  default     = {
    "0.5GB"   = "512"
    "1GB"     = "1024"
    "2GB"     = "2048"
    "3GB"     = "3072"
    "4GB"     = "4096"
    "5GB"     = "5120"
    "6GB"     = "6144"
  }
}
variable "container_port" {
  description = "Port exposed on the docker container, defined by the dockerfile"
  default     = 8080
}

variable "container_image" {
  description = "repo path to the the docker container image"
  default     = "stefanscherer/whoami:latest" # "adongy/hostname-docker:latest"
}

# variable "aws_amis" { type = "map"
#   default = {
#     "Virginia" = "ami-2757f631"
#     "Ireland"  = "ami-0ff760d16d9497662"
#   }
# }
# variable "aws_instance_types"  { type = "map"
#   default = {
#     "Virginia" = "t2.micro"
#     "Ireland"  = "t2.micro"
#   }
# }
################################################################################
################################################################################
