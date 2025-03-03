# K8s-Cluster-AWS-with-TERRAFORM
In this project we deploy a Kubernetes Cluster on AWS using Terraform as Infrastructure as code

# Network.tf file 
we have 3 availability zones for higher availability and fault tolerance.
![image](https://github.com/user-attachments/assets/ecc65c84-3916-424f-820d-dbbaf8ce4584)
![HighAvailability](https://github.com/user-attachments/assets/bb4a461a-02c3-41de-9403-f000bbcb8039)

On this occasion we will use only one NAT gateway, but for productive purposes it is ideal to have several NAT gateways in different areas for greater availability.
![image](https://github.com/user-attachments/assets/51d0ff1e-abe1-4cd7-ab5d-8f306d9a1146)
![NAT](https://github.com/user-attachments/assets/81fd7d50-a048-4ad6-abe6-0fcca2d5e404)

# EKS.tf file 
Having cluster_endpoint_public_access = true is a bad practice since it exposes the Kubernetes API to the internet and can become a vulnerability. This can be avoided by having a private network or a VPN to AWS.
![image](https://github.com/user-attachments/assets/1dd31803-7f88-4f1f-b2ef-2c8f169b0dfd)

![image](https://github.com/user-attachments/assets/3c787c47-b727-4d3b-922f-2cba5f10cba0)

**1. IAM User Data Source**
![image](https://github.com/user-attachments/assets/f761486d-f9a0-47f7-a4b0-1366515f4919)
This section is fetching information about an existing IAM user named __kopsadmin__. The data block here queries the IAM user details by specifying the __user_name__. It will return the IAM user's attributes (e.g., ARN), which can be used later in the configuration.

![image](https://github.com/user-attachments/assets/41b2f579-008a-4da4-b9a8-c733abd92c9b)
A module is being used to create the EKS cluster. The module is sourced from terraform-aws-modules/eks/aws, which is a popular Terraform module for managing EKS clusters. The version = "~> 19.0" ensures that only version 19.x of the module is used.

This part specifies the name of the EKS cluster (jam-eks) and the Kubernetes version (1.27) for the cluster.

![image](https://github.com/user-attachments/assets/4c3f63d1-dc6d-417c-ba9d-cc68b5857569)
The EKS cluster is being set up within a specific VPC (vpc_id) and subnets (subnet_ids). Public and private access to the cluster's endpoint is enabled.

This section enables specific Kubernetes addons, like CoreDNS, the VPC CNI plugin, and Kube-Proxy, and sets their conflict resolution behavior to overwrite.

![image](https://github.com/user-attachments/assets/fb213950-e0eb-4c04-9a88-615ac15d2149)
This enables the automatic management of the aws-auth ConfigMap, which is essential for EKS cluster access control.

The __aws_auth_users__ argument is configuring the __aws-auth__ ConfigMap to allow the IAM user __(kopsadmin)__ to access the cluster with the role of __system:masters__, which gives full control over the cluster.

![image](https://github.com/user-attachments/assets/f633bbcb-698a-4c94-a0a6-263f14a2978e)
This section creates an EKS-managed node group called __node-group__. It defines the scaling properties (desired, max, and min capacity) and the instance type __(t3.medium)__. Tags are added to the node group for organization.

![image](https://github.com/user-attachments/assets/e3bd5428-3f41-45b2-b5da-9bf77affdad0)
These are tags applied to the EKS cluster itself for identification, with "Terraform" and "Environment" tags.

![image](https://github.com/user-attachments/assets/29cbb88a-9228-4cce-ba4b-8077350ccffc)
This data block retrieves information about the EKS cluster created in the previous section (module.eks.cluster_name). It provides details like the cluster's API endpoint and certificate authority.

![image](https://github.com/user-attachments/assets/473f6e42-8d05-4c66-803a-079d86240297)
This retrieves the authentication token needed to access the EKS cluster.

![image](https://github.com/user-attachments/assets/5ee62e5c-a77b-4dfe-8f19-b300eb998bef)
This sets up the Kubernetes provider to interact with the EKS cluster:
+ __host:__ The EKS cluster's API endpoint.
+ __cluster_ca_certificate:__ The certificate authority used to verify the Kubernetes API server.
+ __token:__ The authentication token to access the cluster.

# Terraform.tf file 
![image](https://github.com/user-attachments/assets/96487a6c-db5c-447f-ab82-2b5fe6a80817)
+ __The terraform block__ is defining the required version of Terraform (>= 1.3.7) and the required provider (the AWS provider in this case).

+ __This ensures that the correct version of Terraform__ and the necessary provider are used when running the configuration, helping to avoid compatibility issues.


# Datasource.tf file 
![image](https://github.com/user-attachments/assets/67b53de3-f8d8-4600-b1f3-a626767aace2)

This Terraform code is using the aws_iam_user data source to retrieve information about an existing IAM user in AWS. Let me explain each part:

__1. data "aws_iam_user" "me"__

+ __data:__ This keyword is used in Terraform to define a data block, which is a way to retrieve or query information about existing resources in your infrastructure. Data sources are read-only and allow you to fetch information that can be used elsewhere in your configuration.

+ __"aws_iam_user":__ This specifies that the data source is related to AWS IAM (Identity and Access Management) users. It's a predefined data source in the Terraform AWS provider for querying IAM users.

+ __"me":__ This is the name of the data source. It's a label used within the configuration to refer to the retrieved data. In this case, me is just a chosen name for this specific data source, and it can be used in the rest of the Terraform configuration to refer to this particular IAM user.

+ __2. user_name = "kopsadmin"__
This line specifies the user_name of the IAM user you want to retrieve. In this case, it is set to "kopsadmin", which means Terraform will look for an IAM user named kopsadmin in your AWS account and return its details.

# Provider.tf file 
![image](https://github.com/user-attachments/assets/96227dbe-827d-4e20-8076-31e071f8afe8)
This provider block configures the AWS provider with:

+ A specific AWS region (us-east-1),
+ AWS credentials from the ~/.aws/credentials file, using the personal profile,
+ Configuration settings from the ~/.aws/config file.

By setting this up, Terraform can securely authenticate to AWS and interact with your resources using the credentials and configurations specified in these files.

# Deploying the Infrastructure:
![Screenshot from 2025-02-21 22-19-12](https://github.com/user-attachments/assets/d5e64e96-4c58-430e-bf5e-abe133bfac20)
![Screenshot from 2025-02-21 22-18-49](https://github.com/user-attachments/assets/eed0cdbf-683c-40f4-a19a-0f04f8900fe2)
![Screenshot from 2025-02-21 22-42-55](https://github.com/user-attachments/assets/4f1bd798-258c-4cda-b2d7-0c279a764bc6)
![Screenshot from 2025-02-21 22-44-40](https://github.com/user-attachments/assets/3698a6dd-8b18-448f-9df1-087b4bcf457a)
![Screenshot from 2025-02-21 22-44-51](https://github.com/user-attachments/assets/8896f68f-43b2-4632-9017-f2a25743f193)
![Screenshot from 2025-02-21 23-13-24](https://github.com/user-attachments/assets/937090d7-d4d0-41f4-8312-54289d539cd2)
![Screenshot from 2025-02-24 22-45-56](https://github.com/user-attachments/assets/20750eee-d61b-4466-9317-69322040af03)
![Screenshot from 2025-02-24 23-09-30](https://github.com/user-attachments/assets/84718392-9b1e-4484-a248-6fd524308b7d)
![Screenshot from 2025-02-24 23-12-22](https://github.com/user-attachments/assets/bf2a35bf-ffd4-4546-8953-9b255e32f0f9)
![Screenshot from 2025-02-24 23-08-51](https://github.com/user-attachments/assets/c56a7692-bb8f-4bea-95ad-a48ee679fe0d)


