# Container Debugging — Port Mapping Root Cause Analysis

## Competency
**Demonstrate ability to debug a container.**

## Objective
Diagnose and repair an intentionally misconfigured Docker container without changing application code or impacting unrelated services.

## Lab Environment
- Ubuntu WSL2 with Docker Desktop integration
- Image: `dso-tap-web:best-practices`
- Application: Nginx serving a static HTML page on container port 8080
- Isolated test container: `dso-tap-debug-lab`
- Host port: 8083
- Lab date: October 29, 2026

**Safety boundary:** The existing `dso-tap-web-best` container and `lovefillsmemory_db` PostgreSQL container were not targeted for changes.

## Troubleshooting Workflow: Detect → Investigate → Identify → Fix → Verify

### 1. Establish the baseline

```bash
docker ps -a
```

Observed: `dso-tap-web-best` was `Up (healthy)`; `lovefillsmemory_db` was running. Two older training containers showed `Exited (255)`, but their cause was not investigated or established during this lab.

### 2. Reproduce a controlled failure

```bash
docker run -d \
  --name dso-tap-debug-lab \
  -p 8083:9999 \
  dso-tap-web:best-practices

curl -I --max-time 5 http://localhost:8083
```

**Observed failure:**

```text
curl: (56) Recv failure: Connection reset by peer
```

The application was not reachable through the published host port.

### 3. Inspect application logs

```bash
docker logs --tail 30 dso-tap-debug-lab
```

Observed Nginx worker startup notices and recurring successful internal health-check requests:

```text
127.0.0.1 - - [29/Oct/2026:16:28:30 +0000] "GET / HTTP/1.1" 200 202 "-" "Wget" "-"
```

**Interpretation:** Nginx was serving requests inside the container. The internal health check alone did not establish that the published host port was correct.

### 4. Inspect the port configuration

```bash
docker inspect dso-tap-debug-lab \
  --format 'PortBindings={{json .HostConfig.PortBindings}}'
```

**Observed:**

```text
PortBindings={"9999/tcp":[{"HostIp":"","HostPort":"8083"}]}
```

**Root cause:** The host's port 8083 was mapped to container port **9999**, while Nginx served HTTP on container port **8080**. This is a Docker port publishing misconfiguration, not an application-code defect.

### 5. Apply a targeted fix

Published port mappings cannot be changed in place on an existing Docker container, so the isolated test container was recreated:

```bash
docker stop dso-tap-debug-lab
docker rm dso-tap-debug-lab

docker run -d \
  --name dso-tap-debug-lab \
  -p 8083:8080 \
  dso-tap-web:best-practices
```

The image and application code were unchanged.

### 6. Verify the fix

```bash
curl -I --max-time 5 http://localhost:8083
docker ps --filter name=dso-tap-debug-lab
```

**Observed HTTP result:**

```text
HTTP/1.1 200 OK
Server: nginx/1.31.7
```

**Observed container status and port mapping:**

```text
dso-tap-web:best-practices  Up About a minute (healthy)  0.0.0.0:8083->8080/tcp, [::]:8083->8080/tcp  dso-tap-debug-lab
```

## Evidence Summary

| Check | Before | After |
| --- | --- | --- |
| Published mapping | `8083:9999` (incorrect) | `8083:8080` (correct) |
| External HTTP | `curl: (56) Connection reset by peer` | `HTTP/1.1 200 OK` |
| Internal Nginx response | Health-check GET returned HTTP 200 | Container reported `healthy` |
| Application source/image | Unchanged | Unchanged |
| Root cause | Wrong destination container port | Resolved by recreating the test container |

## Lessons Learned
1. Start with symptoms and gather evidence before changing configuration.
2. `docker ps -a` shows lifecycle status; `docker logs` helps identify application-level failures.
3. `docker inspect` exposes actual runtime port bindings.
4. An internally healthy container can still be unreachable through a misconfigured host port.
5. Apply the smallest targeted change, then repeat the exact failing test.
6. Avoid inferring root causes from exit codes alone.

## Competency Interview Answer

**Question: How do you debug a Docker container?**

I start by checking container status with `docker ps -a` and reproducing the failure. Then I inspect application logs with `docker logs`, examine runtime configuration with `docker inspect`, and test connectivity with `curl`. I use those observations to identify the root cause, apply a targeted fix, and verify that the original failure no longer occurs. In my lab, Nginx responded successfully inside the container, but an incorrect Docker port mapping prevented external access. I corrected the mapping from `8083:9999` to `8083:8080`, then verified HTTP 200 and a healthy container.

## Learning Review — Steps Taken and Lessons Learned

### Steps We Took (and Why)

| Step | Action | Why it mattered |
| --- | --- | --- |
| 1 | Ran `docker ps -a` to inspect existing containers. | Established a baseline and avoided modifying unrelated services. |
| 2 | Created `dso-tap-debug-lab` using `-p 8083:9999`. | Introduced a controlled, isolated port-mapping fault. |
| 3 | Tested `curl -I --max-time 5 http://localhost:8083`. | Reproduced the user-visible failure: connection reset by peer. |
| 4 | Examined `docker logs --tail 30 dso-tap-debug-lab`. | Found Nginx startup notices and internal health-check requests returning HTTP 200. |
| 5 | Inspected `.HostConfig.PortBindings` with `docker inspect`. | Confirmed host port 8083 was incorrectly routed to container port 9999. |
| 6 | Compared the mapping with Nginx's actual port 8080. | Identified the root cause as port publishing, not application code. |
| 7 | Stopped and removed **only** the isolated test container. | Allowed safe recreation without changing the Docker image or other containers. |
| 8 | Recreated the container with `-p 8083:8080`. | Corrected the faulty configuration. |
| 9 | Repeated the original `curl` test and checked `docker ps`. | Confirmed HTTP 200, `healthy` status, and the correct published port. |

### Commands Explained

| Command | Purpose |
| --- | --- |
| `docker ps -a` | Inspect running and stopped containers. |
| `docker run -d --name dso-tap-debug-lab -p 8083:9999 dso-tap-web:best-practices` | Reproduce an intentionally incorrect port binding. |
| `curl -I --max-time 5 http://localhost:8083` | Test external connectivity and capture the symptom. |
| `docker logs --tail 30 dso-tap-debug-lab` | Check whether the application is starting and responding internally. |
| `docker inspect dso-tap-debug-lab --format 'PortBindings={{json .HostConfig.PortBindings}}'` | Inspect the actual host-to-container port configuration. |
| `docker stop dso-tap-debug-lab` | Stop only the training container. |
| `docker rm dso-tap-debug-lab` | Remove the stopped training container before recreating it. |
| `docker run -d --name dso-tap-debug-lab -p 8083:8080 dso-tap-web:best-practices` | Recreate the container with the correct destination port. |
| `docker ps --filter name=dso-tap-debug-lab` | Verify runtime health and the published port after repair. |

### Problem Encountered, Root Cause, and Resolution

**Symptom:** `curl` to `localhost:8083` failed with `curl: (56) Recv failure: Connection reset by peer`.

**Evidence:** Nginx logs showed successful internal `GET /` health-check requests, while `docker inspect` reported `8083 → 9999`.

**Root cause:** Nginx listened on container port 8080, but Docker published host port 8083 to unused container port 9999.

**Resolution:** Recreated the isolated container with `-p 8083:8080` and repeated the same external test.

**Verified outcome:** `HTTP/1.1 200 OK`; container status `Up ... (healthy)`; published port `8083->8080/tcp`.

### Lessons Learned

1. **Healthy does not mean externally reachable.** Internal health checks can pass while host port publishing is wrong.
2. **Reproduce first.** Capture the actual error before changing configuration.
3. **Logs and inspect answer different questions.** `docker logs` shows application behavior; `docker inspect` shows Docker's configuration.
4. **Diagnose the layer that failed.** Here the application was functioning, but the host-to-container network mapping was wrong.
5. **Fix only the root cause.** No code change or image rebuild was necessary.
6. **Retest the original symptom.** The successful `curl` after the fix is stronger evidence than a successful `docker run` alone.
7. **Do not infer root cause from an exit code alone.** The older `Exited (255)` containers were not diagnosed in this exercise.

### How to Explain It to an Evaluator

**Plain-English explanation:** I intentionally reproduced a container connectivity problem. The external curl request failed, but the Nginx logs showed that internal HTTP requests were succeeding. I inspected Docker's port bindings and found that host port 8083 pointed to container port 9999, while Nginx listened on 8080. I recreated only the test container with the correct mapping and verified both HTTP 200 and healthy status.

**Memory aid:** **Detect → Logs → Inspect → Root Cause → Fix → Retest.**

**Analogy:** The kitchen was working, but the customer entrance led to the wrong room. Fixing the entrance solved the problem without rebuilding the kitchen.

## 30-Second Demo Summary

> I reproduced a container connectivity failure by mapping host port 8083 to the wrong container port, 9999. A curl request failed with a connection reset. Docker logs showed Nginx was running and internal health checks returned HTTP 200. I used docker inspect to confirm the incorrect port binding. I stopped and removed only the isolated test container, recreated it with the correct mapping of 8083 to 8080, and verified HTTP 200 and healthy status. No application code or image changes were needed.

## Excel Competency Summary

| Field | Entry |
| --- | --- |
| Competency | Demonstrate ability to debug a container |
| Status | Completed — observed failure, root cause, fix, and retest |
| Tools | Docker CLI, Ubuntu WSL2, Nginx, curl |
| Scenario | Incorrect published container port |
| Detection | `curl: (56) Recv failure: Connection reset by peer` |
| Root Cause | Host port 8083 mapped to container port 9999 instead of 8080 |
| Fix | Recreated isolated test container using `-p 8083:8080` |
| Validation | `HTTP/1.1 200 OK`; `Up (healthy)`; correct port binding |
| Evidence Path | `Modern-Application-Designs/Container-Debugging/README.md` |

## Final Checkpoint
- [x] Baseline environment inspected
- [x] Controlled fault reproduced
- [x] Application logs examined
- [x] Docker port bindings inspected
- [x] Root cause identified from evidence
- [x] Isolated test container recreated with corrected configuration
- [x] External HTTP response verified as 200
- [x] Container health and port mapping verified
- [x] Competency interview answer documented
- [x] 30-second demo summary documented
- [x] Excel competency summary documented

**Outcome:** Demonstrated an evidence-driven Docker container debugging workflow from failure reproduction to verified remediation.
