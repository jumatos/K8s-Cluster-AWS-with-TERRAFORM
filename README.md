# K8s-Cluster-AWS-with-TERRAFORM
In this project we deploy a Kubernetes Cluster on AWS using Terraform as Infrastructure as code


# 1. IAM User Data Source
![image](https://github.com/user-attachments/assets/f761486d-f9a0-47f7-a4b0-1366515f4919)
This section is fetching information about an existing IAM user named kopsadmin. The data block here queries the IAM user details by specifying the user_name. It will return the IAM user's attributes (e.g., ARN), which can be used later in the configuration.

