# IaC Hands-On Lab: Terraform + AWS S3

## 1. Objective

This hands-on lab demonstrates the basic **Infrastructure as Code (IaC)** workflow using **Terraform** and **Amazon S3**.

By completing this lab, you will learn how to:

- Define AWS infrastructure using code
- Preview infrastructure changes with `terraform plan`
- Create and update infrastructure with `terraform apply`
- Remove infrastructure with `terraform destroy`
- Understand the difference between **Desired State** and **Actual State**

---

## 2. What Is Infrastructure as Code?

**Infrastructure as Code (IaC)** means managing infrastructure through code instead of manually configuring resources through a cloud console.

Instead of:

```text
AWS Console → Click → Configure → Create
```

we use:

```text
Terraform Code
      ↓
terraform plan
      ↓
terraform apply
      ↓
AWS Infrastructure
```

### 3rd Grade Analogy

Think of Terraform as a set of LEGO instructions.

The instructions describe what the final LEGO model should look like.

Terraform compares:

```text
Desired State
      ↓
   Terraform
      ↓
Actual Infrastructure
```

and determines what changes are necessary to make the actual infrastructure match the desired state.

---

## 3. Tools Used

| Tool | Purpose |
| --- | --- |
| Terraform | Define and manage infrastructure |
| AWS CLI | Verify AWS resources |
| Amazon S3 | AWS infrastructure resource used in this lab |
| Command Prompt | Execute Terraform and AWS CLI commands |

---

## 4. Prerequisites

Before starting, verify that Terraform and the AWS CLI are installed and that AWS authentication is working.

Run:

```bash
terraform version
aws --version
aws sts get-caller-identity
```

Verify that:

- Terraform is installed
- AWS CLI is installed
- AWS authentication is working
- You are authenticated to the intended AWS account

---

## 5. Project Structure

The project directory will look similar to this after Terraform initialization:

```text
terraform-s3-demo/
│
├── main.tf
├── .terraform/
└── .terraform.lock.hcl
```

> `.terraform/` and `.terraform.lock.hcl` are created by Terraform during initialization.

---

## 6. Step 1 — Create the Terraform Configuration

Create a file named `main.tf`:

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

### Explanation

The `terraform` block defines the providers required by the project.

The `provider` block tells Terraform that we are using AWS and specifies the AWS Region.

```hcl
provider "aws" {
  region = "us-west-2"
}
```

The `resource` block describes the infrastructure we want Terraform to manage.

```hcl
resource "aws_s3_bucket" "demo"
```

In this lab, Terraform will create and manage an Amazon S3 bucket.

> **Note:** S3 bucket names must be globally unique. If `iac-demo-winnie-s3-bucket` is already in use, replace it with another globally unique bucket name.

---

## 7. Step 2 — Initialize Terraform

Run:

```bash
terraform init
```

### Purpose

`terraform init`:

- Initializes the Terraform working directory
- Downloads the required AWS provider
- Creates the `.terraform/` directory
- Creates or updates the provider dependency lock file
- Prepares Terraform to communicate with AWS

Expected output includes:

```text
Terraform has been successfully initialized!
```

---

## 8. Step 3 — Validate the Configuration

Run:

```bash
terraform validate
```

Expected output:

```text
Success! The configuration is valid.
```

This command checks the Terraform configuration for syntax and internal consistency before infrastructure changes are made.

---

## 9. Step 4 — Preview the Infrastructure

Run:

```bash
terraform plan
```

Expected plan summary:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

### What Does This Mean?

Terraform plans to:

- Create 1 resource
- Change 0 resources
- Destroy 0 resources

The symbols used in a Terraform plan help show what will happen. For example:

```text
+ create
~ update in-place
- destroy
```

### Important

`terraform plan` does **not** create the resource.

It shows the changes Terraform expects to make if the configuration is applied.

This gives us an opportunity to review infrastructure changes before making them.

---

## 10. Step 5 — Create the Infrastructure

Run:

```bash
terraform apply
```

Terraform will display the proposed changes again.

When prompted:

```text
Enter a value:
```

enter:

```text
yes
```

Expected output:

```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

The S3 bucket has now been created in AWS.

The workflow so far is:

```text
Terraform Code
      ↓
terraform plan
      ↓
Review Changes
      ↓
terraform apply
      ↓
AWS Infrastructure
```

---

## 11. Step 6 — Verify the S3 Bucket

Run:

```bash
aws s3 ls
```

Verify that your bucket appears in the output.

For this example:

```text
iac-demo-winnie-s3-bucket
```

This confirms that Terraform successfully created the AWS resource.

You have now verified the resource from two perspectives:

```text
Terraform
    ↓
Created Resource
    ↓
AWS CLI
    ↓
Verified Resource
```

---

## 12. Step 7 — Modify the Infrastructure

Now change the desired configuration.

Update the tags in `main.tf`:

```hcl
tags = {
  Name        = "IaC Demo"
  Environment = "Development"
  ManagedBy   = "Terraform"
}
```

Run:

```bash
terraform plan
```

Expected plan summary:

```text
Plan: 0 to add, 1 to change, 0 to destroy.
```

Terraform detected that the desired configuration has changed.

The important concept is:

```text
Terraform Code
      ↓
Desired State
      ↓
Compare
      ↓
Current AWS State
      ↓
Identify Difference
```

Terraform does not need to recreate the bucket just because the configuration changed.

It determines the difference between the desired state and the current infrastructure and plans the required update.

---

## 13. Step 8 — Apply the Change

Run:

```bash
terraform apply
```

Review the proposed change.

When prompted, enter:

```text
yes
```

Expected output:

```text
Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

Terraform updated the existing S3 bucket to match the new configuration.

---

## 14. Step 9 — Verify the Updated State

Run:

```bash
terraform plan
```

When the infrastructure matches the Terraform configuration, Terraform should report:

```text
No changes. Your infrastructure matches the configuration.
```

Conceptually:

```text
Desired State = Actual State
```

Terraform has nothing left to change.

This is one of the most important ideas behind Infrastructure as Code.

---

## 15. Step 10 — Clean Up

Because this is a demo environment, remove the resource when the lab is complete.

Run:

```bash
terraform destroy
```

Terraform will show the resources that it plans to remove.

When prompted, enter:

```text
yes
```

Expected output:

```text
Destroy complete! Resources: 1 destroyed.
```

Verify the result:

```bash
aws s3 ls
```

The demo bucket should no longer appear.

---

## 16. Terraform Lifecycle Demonstrated

This lab demonstrated the complete basic Terraform lifecycle:

```text
              Terraform Code
                    ↓
              terraform init
                    ↓
             terraform validate
                    ↓
              terraform plan
                    ↓
             terraform apply
                    ↓
              AWS Resource
                    ↓
             Change the Code
                    ↓
              terraform plan
                    ↓
          0 add / 1 change / 0 destroy
                    ↓
             terraform apply
                    ↓
               AWS Updated
                    ↓
             terraform plan
                    ↓
               No Changes
                    ↓
             terraform destroy
                    ↓
              AWS Resource
                 Removed
```

The core workflow can be remembered as:

```text
Write
  ↓
Plan
  ↓
Apply
  ↓
Verify
  ↓
Change
  ↓
Plan
  ↓
Apply
  ↓
Destroy
```

---

## 17. Key Takeaways

### Infrastructure as Code

Infrastructure is defined and managed using code rather than only through manual cloud-console configuration.

### Terraform

Terraform manages the infrastructure lifecycle.

```text
Plan → Apply → Update → Destroy
```

### Desired State

The Terraform configuration describes what we want the infrastructure to look like.

### Actual State

The actual state represents the infrastructure that currently exists.

Terraform compares the desired configuration with the existing infrastructure to determine what actions are required.

### Terraform State

Terraform maintains state information about the infrastructure it manages.

By default, local Terraform state is stored in:

```text
terraform.tfstate
```

Terraform uses state information, the configuration, and provider data to determine what needs to change.

> Terraform state can contain sensitive information and should be handled carefully. It should not normally be committed directly to a public Git repository.

### Reproducibility

Because infrastructure is defined as code, the configuration can be:

- Stored in Git
- Version controlled
- Reviewed
- Shared
- Reused
- Automated

This is one of the major advantages of Infrastructure as Code.

---

## 18. Key Commands

### Terraform

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

### AWS Verification

```bash
aws sts get-caller-identity
aws s3 ls
```

---

## 19. One-Sentence Summary

> **Infrastructure as Code allows us to define infrastructure in code and use automation to make the actual environment match the desired state.**

---

## 20. Next Steps

Possible extensions to this lab include:

- Add S3 versioning
- Add S3 encryption
- Add lifecycle rules
- Use Terraform variables
- Use Terraform outputs
- Manage multiple AWS resources
- Store Terraform code in Git
- Configure remote Terraform state
- Add a CI/CD pipeline
- Compare Terraform with Ansible
- Build an EC2 + Nginx example

### Recommended Next Lab

```text
Terraform
    ↓
AWS EC2
    ↓
Ansible
    ↓
Nginx
    ↓
Web Server
```

This next lab demonstrates an important distinction:

> **Terraform = Provision Infrastructure**

> **Ansible = Configure Infrastructure**

Terraform can provision the EC2 instance, networking, and related AWS resources.

Ansible can then configure the operating system and install software such as Nginx.

Together, they demonstrate how infrastructure provisioning and configuration management can work as separate layers of an automated infrastructure workflow.
