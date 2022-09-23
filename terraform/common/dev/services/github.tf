##############################
# GitHub aws_codestarconnections_connection
##############################
resource "aws_codestarconnections_connection" "github" {
  name          = "hkpark130"
  provider_type = "GitHub"

  tags = {
    Name = "github-connection"
  }
}

output "github_connection" {
  value = aws_codestarconnections_connection.github.arn
}
