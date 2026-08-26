# IaaS — Infrastructure as a Service

## Summary

**Infrastructure as a Service (IaaS)** means renting IT infrastructure from a cloud provider instead of buying and maintaining physical hardware yourself.

Examples on AWS include:

- **Amazon EC2** — Virtual servers
- **Amazon EBS** — Storage
- **Amazon VPC** — Virtual networking
- **Elastic Load Balancing** — Distributes traffic

## 3rd-Grade Analogy — Renting a House

Think of **IaaS as renting a house**.

- **AWS / Cloud Provider = Landlord** — Maintains the building and physical infrastructure.
- **Our Engineering Team = Tenant** — Manages what goes inside, such as the operating system, software, applications, configuration, and data.

> **IaaS is like renting a house: the cloud provider maintains the building, while we manage what we put inside it.**

## IaaS vs. IaC

IaaS and IaC are related, but they are different concepts:

```text
IaaS = Infrastructure we RENT

IaC  = Infrastructure we DEFINE
       and MANAGE with code
```

For example:

```text
Terraform (IaC)
      ↓
AWS (IaaS)
      ↓
EC2 / VPC / Storage
```

## One-Sentence Takeaway

> **IaaS provides the cloud infrastructure we rent; IaC provides a way to define and manage infrastructure using code.**

## Detailed Notes

For the complete explanation, see [`IaaS-Explained.md`](IaaS-Explained.md).
