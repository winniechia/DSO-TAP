# PaaS — Platform as a Service

## Summary

**Platform as a Service (PaaS)** is a cloud computing model where the cloud provider supplies not only the underlying infrastructure, but also a managed platform for building, deploying, and running applications.

The engineering team can focus mainly on the **application and its data** instead of managing physical servers, operating systems, patching, and much of the runtime environment.

Examples of PaaS-style services include:

- **AWS Elastic Beanstalk**
- **Azure App Service**
- **Google App Engine**
- **Heroku**

---

## 3rd-Grade Analogy — Renting a Furnished Apartment

Think of **PaaS as renting a furnished apartment**.

With IaaS, we can think of ourselves as renting a house where we still manage many things inside.

With PaaS, more is already prepared for us. The provider maintains the building and prepares much of the environment. We mainly bring what belongs to us and use it.

```text
Cloud Provider
      ↓
Physical Infrastructure
Servers
Networking
Operating System
Runtime / Platform
Patching and Maintenance
      ↓
-------------------------
      ↓
Engineering Team
      ↓
Application
Application Configuration
Data
```

> **PaaS is like renting a furnished apartment. The provider prepares and maintains the environment; we bring our application and use it.**

---

## Application Deployment Example

With an infrastructure-oriented approach, a team may need to manage more of the environment:

```text
Provision Server
      ↓
Configure Operating System
      ↓
Install Runtime
      ↓
Patch and Maintain Server
      ↓
Deploy Application
```

With PaaS, the workflow is closer to:

```text
Write Application
       ↓
Deploy Application
       ↓
Managed Cloud Platform
       ↓
Application Running
```

The provider handles more of the underlying platform so developers can spend more time on application development.

---

## IaaS vs. PaaS

| | IaaS | PaaS |
| --- | --- | --- |
| Simple analogy | Rental house | Furnished apartment |
| Provider manages | Hardware and virtualization | Hardware, OS, runtime/platform |
| Team mainly manages | OS, software, applications, data | Applications and data |
| Infrastructure control | More | Less |
| Infrastructure management work | More | Less |
| Main goal | Control infrastructure | Focus on application development |

A simple way to remember the difference is:

```text
IaaS
= Give me infrastructure.
  I will manage much of the environment.

PaaS
= Give me a platform.
  I want to deploy my application.
```

---

## IaaS, PaaS, and SaaS Analogy

```text
IaaS → Rent the house

PaaS → Rent the furnished apartment

SaaS → Stay at a hotel
       Just use the service
```

As we move from IaaS toward SaaS, the cloud/service provider manages more of the technology stack and the customer manages less.

---

## One-Sentence Takeaway

> **PaaS provides a managed application platform so developers can focus on building and deploying applications instead of managing the underlying servers and operating system.**
