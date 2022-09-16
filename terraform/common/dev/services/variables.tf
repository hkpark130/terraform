variable "aws_profile" {}
variable "aws_region" {}
variable "account_id" {}
variable "env" {}

data "aws_iam_policy_document" "pipeline_s3_policy" {
  version   = "2012-10-17"
  policy_id = "SSEAndSSLPolicy"
  statement {
    sid = "DenyUnEncryptedObjectUploads"
    actions = [
      "s3:PutObject"
    ]
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = ["${aws_s3_bucket.source_artifact.arn}/*"]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values = [
        "aws:kms"
      ]
    }
  }
  statement {
    sid = "DenyInsecureConnections"
    actions = [
      "s3:*"
    ]
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [
      "${aws_s3_bucket.source_artifact.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }
}

locals {
  account = var.aws_profile
}
