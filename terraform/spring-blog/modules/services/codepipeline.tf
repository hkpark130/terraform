##############################
# spring-blog code pipeline
##############################
resource "aws_codepipeline" "codepipeline" {
  name     = "spring-blog"
  role_arn = aws_iam_role.spring_blog_codepipeline_role.arn

  artifact_store {
    location = "codepipeline-ap-northeast-2-586294528232"
    type     = "S3"
  }

  stage {
    name = "Source"
    
    action {
      name             = "Source"
      namespace = "SourceVariables"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "hkpark130/Spring-Blog"
        BranchName       = "master"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      namespace = "DeployVariables"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

      configuration = {
        ApplicationName     = "spring-blog-deploy"
        DeploymentGroupName = "spring"
      }
    }
  }

  tags = {
    # Name = "${local.fqn}-pipeline"
    Name = "${local.service}-pipeline"
  }
}

resource "aws_codestarconnections_connection" "github" {
  name          = "hkpark130"
  provider_type = "GitHub"
}

resource "aws_iam_role" "spring_blog_codepipeline_role" {
  name               = "AWSCodePipelineServiceRole-ap-northeast-2-spring-blog"
  assume_role_policy = data.aws_iam_policy_document.spring_blog_codepipeline_iam_role.json
  path = "/service-role/"
}
