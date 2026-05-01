##############################
# react-intro CodeDeploy
# (codepipeline.tf 의 Deploy 단계가 ApplicationName / DeploymentGroupName 로 참조)
##############################
resource "aws_codedeploy_app" "this" {
  name             = "deploy-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = "react"
  service_role_arn       = "arn:aws:iam::204207504139:role/ec2_codedeploy"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "name"
      type  = "KEY_AND_VALUE"
      value = "ec2-server-hkpark"
    }
  }

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }
}
