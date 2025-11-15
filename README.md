




**Terraform **
EKS Cluster

terraform - It contains all the eks modules, policies required to build an EKS cluster with 3 worker nodes, more information in the README.md

**MongoDB**

mongodb - It contains manifests to deploy mongodb with 2 replicas of StatefulSet, more information in the README.md

**Docker Image**

.github/workflows/docker-build.yaml - To build demo app and push it to DockerHub using the DockerFile present in the Repo

**Demo Application**

app-helm/swimdockerapp - Contains helm chart that reference the docker Image that is built with the workflow


**PACKER**

packer-ami - Contains packer and ansible playbook to build AMI and also check NTP service on the worker nodes


