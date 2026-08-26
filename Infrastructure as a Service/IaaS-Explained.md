# IaaS — Infrastructure as a Service

## 1. What Is IaaS?

**Infrastructure as a Service (IaaS)** is a cloud computing model where we rent fundamental IT infrastructure from a cloud provider instead of purchasing and maintaining the physical hardware ourselves.

Instead of buying physical servers, installing networking equipment, providing storage, and maintaining a data center, a cloud provider such as AWS supplies the underlying infrastructure on demand.

Examples of AWS services commonly associated with the infrastructure layer include:

- **Amazon EC2** — Virtual servers
- **Amazon EBS** — Block storage for servers
- **Amazon VPC** — Virtual networking
- **Elastic Load Balancing** — Distributes network traffic

The cloud provider manages the physical infrastructure, while our engineering team remains responsible for much of what runs on top of it.

---

## 2. 3rd-Grade Analogy — Renting a House

Think of IaaS like **renting a house**.

### Without IaaS

Imagine that you need somewhere to live, but you must first:

```text
Buy land
   ↓
Build the house
   ↓
Install electricity
   ↓
Install plumbing
   ↓
Maintain the building
   ↓
Finally move in
```

This is similar to owning and operating physical IT infrastructure yourself.

### With IaaS

Instead, you rent a house that has already been built.

The landlord takes care of the building itself, but you decide what happens inside the house.

```text
Landlord / Cloud Provider
        ↓
Building
Electricity
Plumbing
Physical maintenance

        ↓
-------------------------
        ↓

You / Engineering Team
        ↓
Furniture
Decorations
Your belongings
How you use the house
```

In cloud computing terms:

```text
AWS / Cloud Provider
        ↓
Physical Data Center
Physical Servers
Networking Hardware
Virtualization
        ↓
-------------------------
        ↓
Our Engineering Team
        ↓
Operating System
Software
Applications
Configuration
Data
```

A simple way to explain IaaS to a team member is:

> **IaaS is like renting a house. AWS owns and maintains the building, while we decide what goes inside and manage how we use it.**

---

## 3. Why Use IaaS?

IaaS allows teams to obtain infrastructure without purchasing and maintaining physical hardware.

Benefits include:

- Faster infrastructure provisioning
- No need to purchase physical servers
- Ability to scale resources when needed
- Pay for cloud resources based on usage and pricing model
- Infrastructure can be automated
- Easier experimentation and environment creation

---

## 4. Shared Responsibility

Using IaaS does not mean the cloud provider manages everything.

The responsibilities are divided between the cloud provider and the customer.

A simplified view is:

| Cloud Provider | Engineering Team |
| --- | --- |
| Physical data center | Operating system configuration |
| Physical servers | Installed software |
| Physical networking | Applications |
| Hardware maintenance | Application configuration |
| Virtualization infrastructure | Data and appropriate access configuration |

The exact responsibility boundary depends on the specific cloud service being used.

---

## 5. IaaS Example on AWS

Suppose our team needs a Linux web server.

Without cloud infrastructure, we might need to purchase and install a physical server.

With AWS IaaS, we can provision infrastructure such as:

```text
Amazon VPC
     ↓
Subnet
     ↓
Security Group
     ↓
Amazon EC2
     ↓
EBS Storage
```

AWS provides the underlying infrastructure while our team configures and operates the workloads running on it.

---

## 6. IaaS and Terraform

IaaS and Infrastructure as Code (IaC) are related, but they are not the same thing.

### IaaS

Describes **the infrastructure service we consume from a cloud provider**.

### IaC

Describes **how we define and manage infrastructure using code**.

For example:

```text
Terraform
    ↓
Infrastructure as Code (IaC)
    ↓
AWS APIs
    ↓
Cloud Infrastructure
    ↓
EC2 / VPC / Storage / Networking
```

A simple way to remember the difference is:

> **IaaS = Infrastructure we rent.**
>
> **IaC = Infrastructure we define and manage with code.**

---

## 7. Example: Terraform Provisioning AWS Infrastructure

Terraform can be used to provision infrastructure resources instead of creating them manually in the AWS Management Console.

For example:

```text
Terraform Configuration
        ↓
terraform plan
        ↓
terraform apply
        ↓
AWS
        ↓
EC2 + VPC + Storage
```

This combines two concepts:

```text
IaaS
= Cloud infrastructure provided as a service

IaC
= Infrastructure defined and managed as code
```

---

## 8. One-Sentence Summary

> **Infrastructure as a Service (IaaS) lets us rent computing infrastructure from a cloud provider instead of buying and maintaining the physical hardware ourselves.**

### 3rd-Grade Version

> **IaaS is like renting a house: the landlord takes care of the building, and you take care of what you put inside it.**
