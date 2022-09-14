provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}

# "terraform-s3-state" 버킷을 미리 생성해야 함!
# terraform {
#   backend "s3" {
#     profile = "portfolio"
#     region  = "ap-northeast-2"
#     bucket  = "terraform-s3-state"
#     key     = "common/dev/services/terraform.tfstate"
#   }
# }
