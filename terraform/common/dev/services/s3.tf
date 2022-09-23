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
  policy = data.aws_iam_policy_document.pipeline_s3_policy.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "source_artifact" {
  bucket = aws_s3_bucket.source_artifact.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "source_artifact_s3" {
  value = aws_s3_bucket.source_artifact.bucket
}
