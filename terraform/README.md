Pre-requisites:

1. Install terraform
2. Install packer
3. Install ansible
4. Install kubectl
5. Install aws cli
6. Permission to create resources part of EKS cluster

To create the cluster follow below steps:

1. Create the AMI using packer
2. Create the cluster using terraform

To destroy the cluster follow below steps:

1. Destroy the cluster using terraform
2. Destroy the AMI using packer

S3 bucket and DynamoDB table are used for state management. Which are not included in the code and needs to create manually. 

To create the S3 bucket and DynamoDB table follow below steps:

1. Create the S3 bucket
2. Create the DynamoDB table

To create EKS cluster, follow below steps:

terraform init -backend-config="bucket=<S3bucketname>" -backend-config="key=eks/dev/terraform.tfstate" -backend-config="region=us-east-1" -backend-config="dynamodb_table=terraform-locks"
terraform apply