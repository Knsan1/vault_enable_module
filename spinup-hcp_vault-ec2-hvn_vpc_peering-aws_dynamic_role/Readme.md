# Terraform AWS & HCP Vault Setup

## Prerequisites

- AWS account with full access.
- HCP account with full access.
- Create a key-pair for EC2 instances in the AWS account (SG region).

### Summary of the Terraform Code

This Terraform configuration sets up a cloud infrastructure for deploying and integrating AWS resources with HCP Vault for secret management. Here's a breakdown of what the code does:

1. **VPC Creation with Public, Private, and DB Subnets**:  
   A Virtual Private Cloud (VPC) is created in the AWS `ap-southeast-1` region with three sets of subnets:
   - **Public Subnets**: `10.20.1.0/24` and `10.20.2.0/24`.
   - **Private Subnets**: `10.20.3.0/24` and `10.20.4.0/24`.
   - **DB Subnets**: `10.20.5.0/24` and `10.20.6.0/24`.

2. **Vault Cluster Deployment on HCP**:  
   A Vault cluster is deployed on HashiCorp Cloud Platform (HCP) with a specific HVN (HashiCorp Virtual Network). The Vault cluster uses the `ap-southeast-1` AWS region and is created under the "dev" tier.

3. **HVN Peering with AWS VPC**:  
   This module establishes peering between the VPC created on AWS and the HVN created on HCP. The peering allows secure communication between the Vault cluster and AWS resources.

4. **EC2 Instances**:  
   Three EC2 instances are launched in the AWS VPC, one in each of the following subnets:
   - **Public EC2 (Jump Host)**: A publicly accessible instance in the public subnet.
   - **Private EC2 Instance**: An instance in the private subnet.
   - **DB EC2 Instance**: An instance in the DB subnet.

5. **IAM User Creation**:  
   An IAM user named `vault-admin` is created on AWS with a policy that grants permissions for managing access keys, users, and other IAM resources. This user is used for configuring Vault's AWS secrets engine.

6. **AWS Secret Engine on Vault**:  
   Vault’s AWS Secrets Engine is enabled and configured to use the `vault-admin` IAM user’s access keys. The engine dynamically manages AWS credentials for IAM roles.

7. **Dynamic EC2 Role Creation**:  
   A dynamic EC2 admin role is created in Vault's AWS secret engine. This role allows Vault to issue temporary credentials that grant EC2-related permissions in AWS.

8. **Outputs**:  
   The code outputs various details, including:
   - Public and private IPs, DNS names, and instance IDs for the EC2 instances.
   - Vault cluster endpoints (public and private).
   - Vault backend paths and IAM user details for secrets management.

This setup integrates AWS infrastructure with HCP Vault to manage dynamic AWS credentials securely, using EC2 instances across multiple subnets to simulate a production-like environment.

## Export Environment Variables

```bash
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxx"
export HCP_CLIENT_ID="xxxxxxxxxx"
export HCP_CLIENT_SECRET="xxxxxxxxxx"
```

## Run Terraform Code

1. Initialize Terraform:

   ```bash
   terraform init
   ```

2. Format Terraform files:

   ```bash
   terraform fmt
   ```

3. Validate the Terraform configuration:

   ```bash
   terraform validate
   ```

4. Plan the Terraform execution:

   ```bash
   terraform plan
   ```

   > **Note**: During the planning phase, an error related to VPC module dependency may occur. Apply the VPC module first.

5. Apply the VPC module:

   ```bash
   terraform apply -target=module.vpc
   ```

6. Re-run the Terraform plan and apply the configuration:

   ```bash
   terraform plan
   terraform apply -auto-approve
   ```

7. Check the state:

   ```bash
   terraform state list
   ```

## Copy the PEM Key to the Public EC2 Instance (Jump Host)

```bash
scp -i sg-ec2-keypair.pem sg-ec2-keypair.pem ubuntu@13.229.65.49:/tmp/.
```

## Access the Public EC2 Instance (Jump Host)

1. SSH into the Public EC2 instance:

   ```bash
   ssh -i sg-ec2-keypair.pem ubuntu@13.229.65.49
   ```

2. From the Public EC2 instance, SSH into the Private EC2 instance:

   ```bash
   ssh -i /tmp/sg-ec2-keypair.pem ubuntu@10.20.3.171
   ```

## Install Vault on the Private EC2 Instance

```bash
sudo apt -y update && sudo apt -y install gpg wget
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt -y update && sudo apt -y install vault
vault version
```

## Check Mapping of IP for URL

```bash
nslookup kns-vault-cluster01-private-vault-7c6c4b2e.11f41fcd.z1.hashicorp.cloud
```

## Export Vault Environment Variables

```bash
export VAULT_ADDR="https://kns-vault-cluster01-private-vault-7c6c4b2e.11f41fcd.z1.hashicorp.cloud:8200"
export VAULT_NAMESPACE="admin"
export VAULT_TOKEN="xxxxxxxxxxxxxxxxx"
```

## Test Dynamic Role

1. Check Vault status:

   ```bash
   vault status
   ```

2. List Vault secrets:

   ```bash
   vault secrets list
   ```

3. Read the dynamic role:

   ```bash
   vault read kns-aws-master/role/ec2-admin-role
   vault read kns-aws-master/creds/ec2-admin-role
   ```

---
