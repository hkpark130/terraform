##############################
# GitHub aws_codestarconnections_connection
##############################
resource "aws_codestarconnections_connection" "github" {
  name          = "hkpark130"
  provider_type = "GitHub"
}

output "github_connection" {
  value = aws_codestarconnections_connection.github.arn
}
