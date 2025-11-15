To execute the playbook follow below command 

ANSIBLE_INVENTORY_ENABLED=amazon.aws.aws_ec2 \
ansible-playbook -i inventory.aws_ec2.yaml ntp+k8s.yml -l workers

To build the AMI follow below command 

packer init worker.pkr.hcl
packer validate -var 'region=us-east-1' worker.pkr.hcl
packer build -var 'region=us-east-1' worker.pkr.hcl

Use the AMI:
Create an Auto Scaling Group/Launch Template for your cluster.
