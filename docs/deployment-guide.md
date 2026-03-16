# Deployment Guide

This guide explains how to deploy the Azure Landing Zone infrastructure using Terraform.

The infrastructure includes platform resources, networking, governance controls, and a sample workload deployment.

---

# Prerequisites

Before deploying the environment, ensure the following tools are installed.

Required Tools

• Terraform (version 1.6 or later)
• Azure CLI
• Git

You must also have an **Azure subscription** with permission to create resources.

---

# Clone the Repository

Clone the project repository locally.

```
git clone <repository-url>
cd terraform-azure-landing-zone
```

---

# Authenticate with Azure

Log in to Azure using the Azure CLI.

```
az login
```

Verify the correct subscription is selected.

```
az account show
```

If necessary, set the subscription.

```
az account set --subscription <subscription-id>
```

---

# Configure Terraform Variables

Navigate to the environment configuration.

```
environments/dev
```

Edit the `terraform.tfvars` file.

Example configuration:

```
location        = "eastus2"
environment     = "dev"
subscription_id = "<your-subscription-id>"
```

---

# Initialize Terraform

Terraform must be initialized before deployment.

```
terraform init
```

This step will:

• Download the required Terraform providers
• Configure the remote Terraform backend
• Initialize the working directory

---

# Validate the Configuration

Validate the Terraform configuration.

```
terraform validate
```

This ensures the configuration is syntactically correct.

---

# Review the Deployment Plan

Generate a Terraform plan to preview the infrastructure changes.

```
terraform plan
```

The plan will display the resources that will be created.

---

# Deploy the Infrastructure

Apply the Terraform configuration.

```
terraform apply
```

Terraform will display a summary of resources that will be created.

Type:

```
yes
```

to confirm the deployment.

---

# Resources Created

The deployment will create the following components.

Resource Groups

• rg-platform-management-dev
• rg-platform-connectivity-dev
• rg-workload-dev

Networking

• Hub Virtual Network
• Spoke Virtual Network
• Hub-Spoke VNet Peering

Governance

• Azure Policy assignments
• RBAC role assignments

Platform Services

• Log Analytics Workspace

Workload Resources

• Storage Account
• Key Vault

---

# Verify the Deployment

After deployment, verify the environment in the Azure Portal.

Check the following resources:

Virtual Networks

• vnet-hub-dev
• vnet-spoke-dev

VNet Peering

• Hub to Spoke
• Spoke to Hub

Policy Assignments

• Allowed Locations
• Require Environment Tag

Workload Resources

• Storage Account
• Key Vault

---

# Destroying the Environment

To remove all deployed infrastructure, run:

```
terraform destroy
```

Terraform will display the resources that will be deleted.

Confirm the operation when prompted.

---

# Troubleshooting

Common issues during deployment include:

Authentication errors

Ensure you are logged in using:

```
az login
```

Incorrect subscription

Verify the active subscription using:

```
az account show
```

Terraform state lock

If Terraform state becomes locked, unlock using:

```
terraform force-unlock <lock-id>
```
