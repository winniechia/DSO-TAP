# Kubernetes Distribution Selection Based on Development Team Needs

## Competency
**Demonstrate ability to select an appropriate distribution of Kubernetes based on the needs of a development team.**

**Lab date:** October 29, 2026  
**Selected solution:** kind (Kubernetes in Docker) v0.27.0  
**Environment:** Windows PowerShell, Ubuntu WSL2 (linux/amd64), Docker Desktop / Docker Engine 29.5.3

## 1. Objective and Scenario

Act as a DevOps engineer supporting a **hypothetical five-developer team** that needs to develop and test a containerized web application. The team already uses Docker, has limited Kubernetes experience, wants low infrastructure cost, and may integrate GitHub Actions in the future. A production Kubernetes environment is **not** required for this exercise.

The objective is to compare realistic Kubernetes options, explain the selection, and validate it by creating a cluster and deploying a working application.

> **Scope distinction:** This is a local development/test architecture decision, not a recommendation to use kind for production.

## 2. Development Team Requirements

| Criterion | Team requirement | Decision impact |
| --- | --- | --- |
| Team size | 5 developers (scenario assumption) | Prefer low operational overhead |
| Workload | Containerized web application | Needs standard Kubernetes deployment support |
| Current environment | Docker Desktop + Ubuntu WSL2 | Prefer Docker-compatible local solution |
| Budget | Minimize new cloud spending | Favor local cluster |
| Experience | Kubernetes beginners | Favor easy setup and teardown |
| CI/CD | Potential GitHub Actions integration | Favor reproducible, scriptable clusters |
| Availability | No production SLA for this lab | No managed production control plane needed |
| Scope | Local development and validation | No public ingress or multi-region requirement |

## 3. Kubernetes Options and Decision Matrix

| Option | Category | Advantages for this team | Tradeoffs | Fit |
| --- | --- | --- | --- | --- |
| **kind** | Local Kubernetes cluster tool using Docker containers | Lightweight, reproducible, good for CI testing, reuses Docker | Not a managed production platform; local resource constraints | **Best fit** |
| **Minikube** | Local Kubernetes development tool | Beginner-friendly, interactive local testing, add-ons | More configuration/runtime choices; not required for this CI-oriented scenario | Strong alternative |
| **k3s** | Lightweight Kubernetes distribution | Suitable for lightweight/edge deployments and small persistent clusters | More cluster administration than needed for this disposable local test | Conditional fit |
| **MicroK8s** | Lightweight Kubernetes distribution | Local or small-scale Kubernetes deployments | Additional installation and operational model compared with existing Docker workflow | Conditional fit |
| **Amazon EKS** | AWS-managed Kubernetes service | Managed control plane and AWS integration for production | Cloud costs, IAM/network setup, greater operational scope | Not justified for this lab |
| **AKS / GKE** | Cloud-managed Kubernetes services | Managed platforms suited to Azure / Google Cloud environments | Cloud infrastructure and provider-specific operations | Not justified for this lab |
| **Red Hat OpenShift** | Enterprise Kubernetes platform | Enterprise governance, security and integrated developer capabilities | Higher platform complexity than the scenario requires | Not justified for this lab |

**Decision:** Select **kind** for local development and future automated CI validation because it aligns with the team's existing Docker environment, minimizes infrastructure cost, and supports reproducible disposable clusters.

**Revisit the decision when:** The team needs production SLAs, managed upgrades, persistent workloads, enterprise governance, external traffic, or AWS integration. In an AWS production scenario, evaluate Amazon EKS against operational and cost requirements.

**Terminology note:** kind and Minikube are primarily local cluster tools; k3s and MicroK8s are lightweight distributions; EKS, AKS, and GKE are managed Kubernetes services. They are compared here as practical ways a team might obtain Kubernetes, not as identical product categories.

## 4. Architecture

```text
Windows PowerShell
    |
    | curl.exe -I http://localhost:8084
    v
Ubuntu WSL2 (kubectl port-forward)
    |
    v
kind cluster: dso-tap
    |
    +-- Node: dso-tap-control-plane (Ready, Kubernetes v1.32.2)
          |
          +-- Deployment: dso-tap-nginx
                |
                +-- Pod: dso-tap-nginx-795bd4b5-6rpvd (1/1 Running)
                      |
                      +-- Nginx :80
```

The port-forward was temporary and was stopped after validation. It is not a production ingress design.

## 5. Hands-on Steps Taken and Verified Evidence

### Step 1 — Inspect existing tools and configuration

```bash
command -v kubectl || echo "kubectl not installed"
kubectl config get-contexts
command -v kind || echo "kind not installed"
docker info --format 'Server Version: {{.ServerVersion}}'
uname -m
```

**Observed:**
- `kubectl` at `/usr/local/bin/kubectl`.
- `kubectl config get-contexts` showed column headings but no contexts.
- `kind not installed`.
- Docker Engine server version `29.5.3`.
- CPU architecture `x86_64`.

**Why:** Confirm prerequisites and select the correct installation artifact before changing the environment.

### Step 2 — Download the Linux AMD64 binary

```bash
curl -Lo /tmp/kind https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64
file /tmp/kind
```

**Observed file type:** `ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, not stripped`.

### Step 3 — Verify file integrity and resolve a filename issue

```bash
curl -fsSL -o /tmp/kind.sha256sum https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64.sha256sum
cd /tmp && sha256sum -c kind.sha256sum
```

**Initial observed error:**

```text
sha256sum: kind-linux-amd64: No such file or directory
kind-linux-amd64: FAILED open or read
sha256sum: WARNING: 1 listed file could not be read
```

**Root cause:** The downloaded binary was named `/tmp/kind`, while the checksum manifest expected `kind-linux-amd64`. This was a file lookup error, **not** evidence of a hash mismatch.

```bash
mv /tmp/kind /tmp/kind-linux-amd64
sha256sum -c /tmp/kind.sha256sum
```

**Verified result:**

```text
kind-linux-amd64: OK
```

### Step 4 — Install and verify kind

```bash
sudo install -m 0755 /tmp/kind-linux-amd64 /usr/local/bin/kind
kind version
```

**Observed:**

```text
kind v0.27.0 go1.23.6 linux/amd64
```

### Step 5 — Create the cluster and check the node

```bash
kind create cluster --name dso-tap
kubectl get nodes
```

**Observed cluster creation:** Node image `kindest/node:v1.32.2`; node preparation, configuration, control plane, CNI and StorageClass setup completed; context set to `kind-dso-tap`.

**Observed node:**

```text
NAME                    STATUS   ROLES           AGE   VERSION
dso-tap-control-plane   Ready    control-plane   99s   v1.32.2
```

### Step 6 — Deploy Nginx and check the Pod

```bash
kubectl create deployment dso-tap-nginx --image=nginx:stable-alpine
kubectl get pods
```

**Observed:**

```text
deployment.apps/dso-tap-nginx created

NAME                           READY   STATUS    RESTARTS   AGE
dso-tap-nginx-795bd4b5-6rpvd   1/1     Running   0          59s
```

### Step 7 — Validate application connectivity

In the first Ubuntu terminal:

```bash
kubectl port-forward deployment/dso-tap-nginx 8084:80
```

**Observed:**

```text
Forwarding from 127.0.0.1:8084 -> 80
Forwarding from [::1]:8084 -> 80
```

In Windows PowerShell, the initial Linux-style `curl -I --max-time 5 http://localhost:8084` command failed because `curl` resolved to PowerShell's `Invoke-WebRequest` alias.

**Resolution:**

```powershell
curl.exe -I --max-time 5 http://localhost:8084
```

**Verified result:**

```text
HTTP/1.1 200 OK
Server: nginx/1.30.6
Content-Type: text/html
Content-Length: 896
```

The temporary port-forward was subsequently stopped with **Ctrl+C** as confirmed by the operator.

## 6. Commands Explained

| Command | Purpose |
| --- | --- |
| `kubectl config get-contexts` | Show Kubernetes contexts configured for the CLI |
| `docker info` | Check connectivity to the Docker Engine |
| `uname -m` | Identify CPU architecture for binary selection |
| `file` | Inspect the downloaded binary's format (not its integrity) |
| `sha256sum -c` | Compare the downloaded file with the supplied checksum manifest |
| `sudo install -m 0755` | Install an executable with the specified permissions |
| `kind version` | Confirm kind is runnable and identify its version |
| `kind create cluster --name dso-tap` | Create a local Kubernetes cluster using Docker |
| `kubectl get nodes` | Check node status and Kubernetes version |
| `kubectl create deployment` | Declare an application Deployment |
| `kubectl get pods` | Inspect actual Pod readiness and restart count |
| `kubectl port-forward` | Create a temporary local connection to the workload |
| `curl.exe -I` | Test HTTP response headers from Windows PowerShell |

## 7. Problems Encountered and Resolutions

| Problem | Root cause | Resolution | Evidence |
| --- | --- | --- | --- |
| Checksum command could not read the binary | Manifest expected `kind-linux-amd64`, but file was named `kind` | Rename binary and rerun verification | `kind-linux-amd64: OK` |
| PowerShell rejected Linux `curl` options | `curl` resolved to `Invoke-WebRequest` alias | Invoke native `curl.exe` | `HTTP/1.1 200 OK` |

## 8. Lessons Learned

1. **Requirements first:** Kubernetes platform selection should reflect the team's budget, operational maturity, development workflow, CI/CD goals and production needs.
2. **Local tools differ from managed platforms:** kind is appropriate for disposable local and CI clusters; it does not replace a production managed Kubernetes service.
3. **Prerequisite checks prevent rework:** Verify Docker connectivity, architecture, and existing contexts before installing software.
4. **File type is not integrity:** `file` identifies format; SHA-256 checks content against a trusted published checksum.
5. **File not found is not hash mismatch:** Read checksum errors carefully before assuming a corrupt download.
6. **Created is not Ready:** A cluster creation success message should be followed by a node readiness check.
7. **Running is not reachable:** A Pod in `Running` state should still be tested at the application layer.
8. **Shells behave differently:** Windows PowerShell `curl` may be an alias; `curl.exe` invokes the native executable.
9. **Temporary forwarding is for testing:** `kubectl port-forward` is not a production exposure strategy.
10. **Evidence over assumptions:** Record actual output before marking a lab step complete.

**Memory aid:** **Requirements → Compare → Select → Install → Cluster → Pod → HTTP → Explain.**

## 9. How to Explain It to an Evaluator

**Question: How do you select the appropriate Kubernetes distribution for a development team?**

I start by evaluating the development team's requirements: team size, budget, current infrastructure, Kubernetes experience, CI/CD plans, and whether production availability is needed. For a hypothetical five-developer team already using Docker and needing low-cost local testing, I compared kind, Minikube, lightweight distributions such as k3s, and managed services such as Amazon EKS. I selected kind because it supports reproducible local Kubernetes clusters without requiring paid cloud infrastructure. I then verified the Docker environment, installed and checksum-verified kind, created a cluster, deployed Nginx, and confirmed the node was Ready, the Pod was Running, and the application returned HTTP 200. I would reassess the platform if production or enterprise requirements changed.

## 10. 30-Second Demo Summary

> I evaluated a five-developer team's needs for low-cost local Kubernetes testing and compared kind, Minikube, k3s and Amazon EKS. I selected kind because the team already used Docker and did not need a production cluster. I verified the kind binary with SHA-256, created a Kubernetes cluster, deployed Nginx, and checked that the node was Ready and the Pod was Running. Finally, I used port-forwarding and curl.exe to confirm HTTP 200. This validated the selection against the team's development needs.

## 11. Excel Competency Summary

| Field | Entry |
| --- | --- |
| Competency | Demonstrate ability to select appropriate distribution of Kubernetes based on development team needs |
| Status | Completed — decision and local proof of concept verified |
| Team scenario | 5 developers; Docker-based web app; low-cost local development and future CI/CD |
| Options evaluated | kind, Minikube, k3s, MicroK8s, EKS, AKS/GKE, OpenShift |
| Selected solution | kind v0.27.0 |
| Selection rationale | Docker-native, reproducible, low-cost, suitable for local and CI testing |
| Environment | Ubuntu WSL2, Docker Engine 29.5.3, Windows PowerShell |
| Kubernetes version | v1.32.2 |
| Cluster / context | `dso-tap` / `kind-dso-tap` |
| Workload | `dso-tap-nginx` using `nginx:stable-alpine` |
| Validation | Node Ready; Pod 1/1 Running; 0 restarts; HTTP 200 |
| Troubleshooting | Checksum filename mismatch; PowerShell curl alias |
| Evidence | This README and observed terminal outputs |

## 12. Final Checkpoint

- [x] Development team requirements documented
- [x] Alternative Kubernetes options compared
- [x] Selection justified for the scenario
- [x] Prerequisites checked
- [x] kind download and SHA-256 checksum verified
- [x] kind installed and version verified
- [x] Cluster created
- [x] Node Ready verified
- [x] Nginx Deployment created
- [x] Pod 1/1 Running verified
- [x] HTTP 200 verified from Windows PowerShell
- [x] Temporary port-forward stopped
- [x] Steps taken and commands explained
- [x] Problems, resolutions, and lessons learned documented
- [x] Evaluator answer and 30-second demo included
- [x] Excel competency summary included

**Outcome:** Demonstrated requirements-based Kubernetes platform selection and validated kind through a working local deployment. This does not constitute a production-readiness assessment.
