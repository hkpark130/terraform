PROJECT_ROOT := $(shell git rev-parse --show-cdup)
PROJECT 	 := $(shell echo ${PWD} | rev | cut -d '/' -f 3 | rev)
ENV 		 := $(shell echo ${PWD} | rev | cut -d '/' -f 2 | rev)
PLAN_OUT   	 := ./.terraform/default.plan

COMMON_VAR_FILE := $(PROJECT_ROOT)terraform/${PROJECT}/tfvars/common.tfvars
VAR_FILE 		:= $(PROJECT_ROOT)terraform/${PROJECT}/tfvars/${ENV}.tfvars
VAR_OPTIONS 	:= -var-file "$(COMMON_VAR_FILE)" -var-file "$(VAR_FILE)"

.PHONY: setup install-terraform init-terraform plan

setup: install-terraform init-terraform
	$(info Setup completed.)

install-terraform:
	tfenv install

init-terraform:
	rm -rf .terraform
	terraform init

fmt: 
	terraform fmt

plan: fmt
	terraform plan $(VAR_OPTIONS) \
	-compact-warnings \
	-parallelism 10 \
	-out $(PLAN_OUT)
