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

data "aws_iam_policy_document" "go_jwt_codepipeline_iam_role_policy" {
  statement {
    actions = [
      "codebuild:StartBuild",
    ]

    resources = [
      "*",
    ]
  }
}

locals {
  service = "go-jwt"

  fqn = "${local.service}-${var.env}"
}
