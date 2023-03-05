# Terraform

## aws
```sh
% curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
% sudo installer -pkg ./AWSCLIV2.pkg -target /
% aws --version
```

### credentials 설정후 aws 명령어를 사용할 수 있는지 확인
```sh
% aws s3 ls --profile portfolio
```

## terraform
```sh
% brew install tfenv
% cd path/to/Terraform
% tfenv install
% terraform version
```

## 로컬에서 Import
```sh
% cd path/to/Project Folder
% make setup
% terraform import -var-file "../../tfvars/common.tfvars" -var-file "../../tfvars/dev.tfvars" aws_instance.this i-~
% make plan
```
