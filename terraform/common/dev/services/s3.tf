##############################
# s3
##############################
resource "aws_s3_bucket" "source_artifact" {
  bucket = "codepipeline-ap-northeast-2-586294528232"

  tags = {
    Name = "codepipeline-ap-northeast-2"
  }
}

resource "aws_s3_bucket_policy" "pipeline_s3_policy" {
  bucket = aws_s3_bucket.source_artifact.id
  # policy = data.aws_iam_policy_document.pipeline_s3_policy.json

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "SSEAndSSLPolicy",
  "Statement": [
    {
      "Sid": "DenyUnEncryptedObjectUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.source_artifact.arn}/*",
      "Condition": {
         "StringNotEquals": {"s3:x-amz-server-side-encryption": "aws:kms"}
      }
    },
    {
      "Sid": "DenyInsecureConnections",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.source_artifact.arn}/*",
      "Condition": {
         "Bool": {"aws:SecureTransport": "false"}
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_server_side_encryption_configuration" "source_artifact" {
  bucket = aws_s3_bucket.source_artifact.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
