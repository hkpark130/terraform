provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Env     = var.env
      Service = local.service
    }
  }
}

# "terraform-s3-state" 버킷을 미리 생성해야 함!
terraform {
  backend "s3" {
    profile = "portfolio"
    region  = "ap-northeast-2"
    bucket  = "hkpark-terraform-s3-state"
    key     = "react-intro/dev/services/terraform.tfstate"
  }
}
