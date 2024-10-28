# AWS EKS Redis cluster environment

Repo overview:
- EKS cluster created Terraform resources
- Helm deployment of Redis K8S StatefulSet architecture with dynamically provisioned 1 GB EBS volumes
- Created IAM user group and roles following best practices
- Application load balancer distributing equal load
- Jenkins pipeline for environment setup automation
