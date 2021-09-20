# aws-terraform-service-deploy

## environment dependencies:
* you need to have the aws credentials installed properly in your env (create a user with admin permission)
* a s3 bucket for the infra terraform backend
* a s3 bucket for the micro service terraform backend
* ecr registry already created
* docker 20.10.7
* aws cli: aws-cli/2.2.11 Python/3.8.8 Linux/5.4.0-77-generic exe/x86_64.ubuntu.18
* terraform: v1.0.2
* npm: 6.14.13
* node: 14.17.1

## deploy the infra
* `cd infra/dev`
* `terraform init`
* `terraform plan` (check the output, then y or n)
* `terraform apply`

## build the service and create push the image to ecr
* `cd service`
* `npm install`
* `docker build -t simple-api .`
* `docker tag ${IMAGE_ID} ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}`
* `aws ecr get-login-password | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com`
* `docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${ECR_REPOSITORY}:simple-api`
* `cd infra/terraform/dev`
* `terraform init`
* `terraform plan` (check the output, then y or n)
* `terraform apply`

