variable "tf_state" {}
variable "aws_region" {}
variable "aws_profile" {}
variable "product" {}
variable "env" {}
variable "default_description" {}

module "go-jwt" {
  source = "../../modules/services/"

  tf_state            = var.tf_state
  aws_region          = var.aws_region
  aws_profile         = var.aws_profile
  product             = var.product
  env                 = var.env
  default_description = var.default_description
}

locals {
  service = "go-jwt"
}
