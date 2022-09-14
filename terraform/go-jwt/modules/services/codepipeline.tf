##############################
# go jwt code pipeline
##############################
resource "aws_codepipeline" "codepipeline" {
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_alias.s3kmskey.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.example.arn
        FullRepositoryId = "my-organization/example"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "test"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ActionMode     = "REPLACE_ON_FAILURE"
        Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
        OutputFileName = "CreateStackOutput.json"
        StackName      = "MyStack"
        TemplatePath   = "build_output::sam-templated.yaml"
      }
    }
  }

  tags = {
    # Name = "${local.fqn}-pipeline"
    Name = "${local.service}-pipeline"
  }
}

resource "aws_codestarconnections_connection" "example" {
  name          = "${local.fqn}-connection"
  provider_type = "GitHub"
}

resource "aws_iam_role" "go_jwt_codepipeline_role" {
  name               = "${local.fqn}-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.go_jwt_codepipeline_iam_role.json
}

resource "aws_iam_role_policy" "firehose_role_policy" {
  name   = "${local.fqn}-codepipeline-role-policy"
  role   = aws_iam_role.go_jwt_codepipeline_role.id

  policy = data.aws_iam_policy_document.go_jwt_codepipeline_iam_role_policy.json
}
