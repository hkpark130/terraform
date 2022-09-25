variable "tf_state" {}
variable "aws_region" {}
variable "aws_profile" {}
variable "product" {}
variable "env" {}
variable "default_description" {}

data "aws_iam_policy_document" "go_jwt_codepipeline_iam_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    profile = "portfolio"
    region  = "ap-northeast-2"
    bucket  = "hkpark-terraform-s3-state"
    key     = "common/dev/services/terraform.tfstate"
  }
}

locals {
  service = "go-jwt"

  fqn = "${local.service}-${var.env}"
}
