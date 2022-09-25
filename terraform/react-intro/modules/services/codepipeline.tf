##############################
# react-intro code pipeline
##############################
resource "aws_codepipeline" "codepipeline" {
  name     = "react-intro-pipe"
  role_arn = aws_iam_role.react_intro_codepipeline_role.arn

  artifact_store {
    location = data.terraform_remote_state.common.outputs.source_artifact_s3
    type     = "S3"
  }

  stage {
    name = "Source"
    
    action {
      name             = "Source"
      namespace        = "SourceVariables"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn        = data.terraform_remote_state.common.outputs.github_connection
        FullRepositoryId     = "hkpark130/React-Intro"
        BranchName           = "master"
        DetectChanges        = true
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      namespace       = "DeployVariables"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

      configuration = {
        ApplicationName     = "deploy-app"
        DeploymentGroupName = "react"
      }
    }
  }

  tags = {
    # Name = "${local.fqn}-pipeline"
    Name = "${local.service}-pipeline"
  }
}

resource "aws_iam_role" "react_intro_codepipeline_role" {
  name               = "AWSCodePipelineServiceRole-ap-northeast-2-react-intro-pipe"
  assume_role_policy = data.aws_iam_policy_document.react_intro_codepipeline_iam_role.json
  path               = "/service-role/"
}
