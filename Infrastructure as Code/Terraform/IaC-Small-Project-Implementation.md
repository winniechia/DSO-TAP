# Implementing Infrastructure as Code on a Small Project with Terraform

## 1. Project Overview

This small project demonstrates how to implement **Infrastructure as Code (IaC)** using **Terraform** to provision and manage an AWS resource.

The project uses an **Amazon S3 bucket** as the example infrastructure because it is simple enough to understand while still demonstrating the complete Terraform workflow.

The goal is not only to create an AWS resource, but to understand how infrastructure can be defined, reviewed, changed, verified, and removed through code.

---

## 2. Project Objective

The objective of this project is to replace manual infrastructure creation with a repeatable Terraform workflow.

Instead of creating the S3 bucket manually in the AWS Management Console:

```text
AWS Console
    ↓
Click through settings
    ↓
Create resource manually
```

we define the infrastructure in Terraform:

```text
Terraform Configuration
        ↓
terraform plan
        ↓
terraform apply
        ↓
AWS Infrastructure
```

This introduces the core IaC principle:

> The infrastructure configuration is stored as code, and Terraform makes the real environment match the desired configuration.

---

## 3. Technologies Used

- **Terraform** — Infrastructure provisioning and lifecycle management
- **AWS** — Cloud platform
- **Amazon S3** — Resource provisioned in this project
- **AWS CLI** — Verification of AWS resources
- **Git / GitHub** — Version control and documentation

---

## 4. Project Architecture

The project is intentionally small:

```text
Developer
   ↓
Terraform Configuration
   ↓
Terraform AWS Provider
   ↓
AWS API
   ↓
Amazon S3 Bucket
```

Terraform communicates with AWS through the AWS provider and creates the S3 bucket defined in the Terraform configuration.

---

## 5. Prerequisites

Before beginning, confirm that Terraform and the AWS CLI are installed and that AWS authentication is working.

```bash
terraform version
aws --version
aws sts get-caller-identity
```

The final command confirms which AWS account and identity are currently being used.

---

## 6. Terraform Configuration

Create a Terraform configuration file named `main.tf`:

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "demo" {
  bucket = "iac-demo-winnie-s3-bucket"

  tags = {
    Name      = "IaC Demo"
    ManagedBy = "Terraform"
  }
}
```

### What This Configuration Does

The configuration contains three important parts.

### Terraform Block

The `terraform` block declares that the project requires the AWS provider.

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
```

### Provider Block

The provider block configures AWS as the cloud provider and sets the deployment Region.

```hcl
provider "aws" {
  region = "us-west-2"
}
```

### Resource Block

The resource block defines the S3 bucket that Terraform should manage.

```hcl
resource "aws_s3_bucket" "demo" {
  bucket = "iac-demo-winnie-s3-bucket"
}
```

> S3 bucket names must be globally unique. A different bucket name may be required if the example name is already in use.

---

## 7. Initialize the Terraform Project

Run:

```bash
terraform init
```

This command:

- Initializes the Terraform working directory
- Downloads the AWS provider
- Creates the `.terraform/` directory
- Creates or updates `.terraform.lock.hcl`

Expected result:

```text
Terraform has been successfully initialized!
```

---

## 8. Validate the Configuration

Run:

```bash
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

This verifies that the Terraform configuration is syntactically valid and internally consistent.

---

## 9. Preview the Infrastructure Change

Run:

```bash
terraform plan
```

Terraform compares the desired configuration with the current infrastructure and produces an execution plan.

For a new project, the expected summary is similar to:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

This means Terraform intends to create one resource.

A key IaC practice is to review the plan before applying changes.

---

## 10. Apply the Infrastructure

Run:

```bash
terraform apply
```

Review the plan and enter:

```text
yes
```

Expected result:

```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

Terraform has now created the S3 bucket in AWS.

---

## 11. Verify the Resource

Use the AWS CLI to confirm that the S3 bucket exists:

```bash
aws s3 ls
```

The created bucket should appear in the output.

This verification step confirms that:

```text
Terraform Configuration
        ↓
Terraform Apply
        ↓
AWS Resource Created
        ↓
AWS CLI Verification
```

---

## 12. Modify the Desired State

One of the most important benefits of IaC is that infrastructure can be changed by modifying the code.

Update the S3 bucket tags:

```hcl
tags = {
  Name        = "IaC Demo"
  Environment = "Development"
  ManagedBy   = "Terraform"
}
```

Then run:

```bash
terraform plan
```

Terraform should detect the difference and show a result similar to:

```text
Plan: 0 to add, 1 to change, 0 to destroy.
```

This demonstrates the relationship between desired state and actual state.

```text
Terraform Code
      ↓
Desired State
      ↓
Compare with AWS
      ↓
Actual State
      ↓
Difference Detected
```

---

## 13. Apply the Update

Run:

```bash
terraform apply
```

After confirmation, Terraform updates the existing resource instead of creating a new one.

Expected result:

```text
Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

---

## 14. Confirm State Convergence

Run:

```bash
terraform plan
```

When no additional changes are needed, Terraform should report:

```text
No changes. Your infrastructure matches the configuration.
```

At this point:

```text
Desired State = Actual State
```

This is the core operating model of Terraform.

---

## 15. Destroy the Infrastructure

Because this is a small learning project, remove the resource after completing the exercise.

Run:

```bash
terraform destroy
```

Review the proposed destruction and enter:

```text
yes
```

Expected result:

```text
Destroy complete! Resources: 1 destroyed.
```

Verify the result:

```bash
aws s3 ls
```

The S3 bucket should no longer appear.

---

## 16. Complete IaC Workflow

This project demonstrates the basic Terraform lifecycle:

```text
Write Terraform Code
        ↓
terraform init
        ↓
terraform validate
        ↓
terraform plan
        ↓
terraform apply
        ↓
Verify AWS Resource
        ↓
Modify Terraform Code
        ↓
terraform plan
        ↓
terraform apply
        ↓
Verify Updated State
        ↓
terraform destroy
```

A shorter version is:

```text
Define → Plan → Apply → Verify → Change → Apply → Destroy
```

---

## 17. Key IaC Concepts Demonstrated

### Infrastructure as Code

Infrastructure is defined in text-based configuration files rather than created only through manual console actions.

### Desired State

The Terraform configuration describes what the infrastructure should look like.

### Actual State

The actual state represents the infrastructure that currently exists in AWS.

### State Management

Terraform tracks managed resources using state information and uses that information when calculating future changes.

### Idempotent Workflow

Running `terraform plan` when the infrastructure already matches the configuration results in no required changes.

### Reproducibility

The Terraform configuration can be version controlled, reviewed, shared, and reused.

### Change Visibility

`terraform plan` gives engineers an opportunity to review proposed infrastructure changes before execution.

---

## 18. Security Considerations

Do not commit AWS access keys, passwords, or other credentials into Terraform files or GitHub.

Terraform state can also contain sensitive information. Files such as:

```text
terraform.tfstate
terraform.tfstate.backup
```

should not normally be committed to a public repository.

A `.gitignore` file should include Terraform-generated local files where appropriate.

Example:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
crash.log
```

For larger or team-based projects, Terraform state should usually be stored in a secured remote backend with appropriate access control and state locking.

---

## 19. What This Small Project Proves

Although this project creates only one S3 bucket, it demonstrates the same fundamental workflow used in larger Terraform environments.

The same process can be expanded to manage:

- VPCs and subnets
- EC2 instances
- Security groups
- Load balancers
- IAM resources
- Databases
- Kubernetes infrastructure
- Multi-environment deployments

The scale changes, but the IaC workflow remains similar.

---

## 20. Next Project

A useful next exercise is to combine Terraform with Ansible:

```text
Terraform
    ↓
Provision EC2
    ↓
Ansible
    ↓
Configure Linux
    ↓
Install Nginx
    ↓
Web Server
```

This demonstrates the difference between infrastructure provisioning and configuration management:

> **Terraform = Provision Infrastructure**

> **Ansible = Configure Infrastructure**

---

## Summary

This small project implemented Infrastructure as Code by defining an AWS S3 bucket in Terraform, reviewing changes with `terraform plan`, provisioning and updating the resource with `terraform apply`, verifying it through the AWS CLI, and removing it with `terraform destroy`.

The most important concept demonstrated is:

> **Terraform uses code to describe the desired infrastructure and manages the real environment so that actual state matches desired state.**
