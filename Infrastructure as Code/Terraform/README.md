# DSO-TAP

## Infrastructure as Code with Terraform — Small AWS Project

This repository documents hands-on DevOps and cloud engineering practice. This small project demonstrates how to implement **Infrastructure as Code (IaC)** using **Terraform** to provision and manage an **Amazon S3 bucket on AWS**.

## Project Goal

The goal is to learn the core IaC workflow by defining infrastructure in code instead of manually creating resources in the AWS Management Console.

Terraform is used to describe the **desired state** of the infrastructure, compare it with the **actual state** in AWS, and determine the changes required to make them match.

```text
Terraform Code
      ↓
Desired State
      ↓
terraform plan
      ↓
terraform apply
      ↓
AWS Infrastructure
```

## Technologies Used

- Terraform
- Amazon Web Services (AWS)
- Amazon S3
- AWS CLI
- Git and GitHub

## What Was Implemented

The project uses Terraform to:

1. Configure the AWS provider in `us-west-2`.
2. Define an Amazon S3 bucket as code.
3. Initialize the Terraform working directory with `terraform init`.
4. Validate the configuration with `terraform validate`.
5. Preview infrastructure changes with `terraform plan`.
6. Provision the S3 bucket with `terraform apply`.
7. Verify the AWS resource using the AWS CLI.
8. Modify the Terraform configuration and observe Terraform detect the difference.
9. Apply the updated desired state.
10. Confirm that the infrastructure matches the configuration.
11. Remove the lab infrastructure with `terraform destroy`.

## Terraform Lifecycle Demonstrated

```text
Write Infrastructure Code
          ↓
    terraform init
          ↓
  terraform validate
          ↓
    terraform plan
          ↓
    terraform apply
          ↓
    AWS S3 Bucket
          ↓
     Modify Code
          ↓
    terraform plan
          ↓
    terraform apply
          ↓
 Infrastructure Updated
          ↓
   terraform destroy
          ↓
 Infrastructure Removed
```

## Key Commands

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

AWS verification:

```bash
aws sts get-caller-identity
aws s3 ls
```

## Key Concepts Learned

### Infrastructure as Code

Infrastructure is defined in version-controlled configuration files rather than created only through manual console operations.

### Desired State vs. Actual State

Terraform configuration represents the desired infrastructure. Terraform compares that configuration with the existing AWS environment and determines what must be created, changed, or destroyed.

### Plan Before Apply

`terraform plan` provides a preview of proposed infrastructure changes before they are executed.

### Reproducibility

Because the infrastructure definition is stored as code, it can be reviewed, version controlled, shared, reused, and automated.

### Infrastructure Lifecycle

Terraform can manage the complete lifecycle of infrastructure:

```text
Plan → Create → Update → Verify → Destroy
```

## Project Documentation

The complete step-by-step lab is available here:

[`AWS-S3-Lab.md`](AWS-S3-Lab.md)

## Security Note

Terraform state may contain sensitive information. Files such as `terraform.tfstate` should not be committed to a public Git repository. AWS credentials and other secrets must also never be stored in source control.

For larger or team-based projects, Terraform state should normally be managed using an appropriate remote backend with suitable access controls and state locking.

## Next Steps

Future exercises can extend this project by adding:

- S3 versioning
- S3 encryption
- Lifecycle rules
- Terraform variables and outputs
- Remote Terraform state
- Additional AWS resources
- CI/CD automation
- EC2 provisioning with Terraform
- Server configuration with Ansible

A useful next project is:

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

This demonstrates the distinction between:

**Terraform = Provision Infrastructure**  
**Ansible = Configure Infrastructure**

---

**Summary:** Infrastructure as Code allows infrastructure to be defined in code and managed through a repeatable workflow so that the actual cloud environment matches the desired state.