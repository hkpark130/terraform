variable "tf_state" {}
variable "aws_region" {}
variable "aws_profile" {}
variable "product" {}
variable "env" {}
variable "default_description" {}

data "aws_iam_policy_document" "spring_blog_codepipeline_iam_role" {
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

locals {
  service = "spring-blog"

  fqn = "${local.service}-${var.env}"
}
