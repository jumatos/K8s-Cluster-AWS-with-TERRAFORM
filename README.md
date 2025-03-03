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

