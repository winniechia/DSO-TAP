# SysAdmin — Small-Team Web Server and Troubleshooting Lab

**Competency:** Server Administration Roles and Responsibilities — Server Admin  
**Requirement:** Demonstrate ability / experience in taking on the role of SysAdmin for a small team and be able to stand up a small server network and troubleshoot issues as they arise.  
**Lab date:** September 29, 2026  
**Environment:** Ubuntu on WSL2, host `msi-aegis-zs2`

## Excel Competency Summary

Demonstrated hands-on SysAdmin experience by installing and operating an Nginx web server on Linux, validating the service and HTTP connectivity, creating a controlled outage, diagnosing the failure with `systemctl`, `ss`, and `journalctl`, restoring the service, and verifying recovery through Port 80 and HTTP `200 OK`.

## Demo Summary / Presentation Talking Points

For this competency, I acted as the SysAdmin for a small Linux environment and stood up an Nginx web service. I verified the service state, confirmed that HTTP Port 80 was listening, and validated the web server with an HTTP `200 OK` response.

I then created a controlled outage by stopping Nginx. The website became unreachable, so I followed a structured troubleshooting process: checked the service state, checked whether Port 80 had a listener, and reviewed the service journal. The evidence showed that Nginx had been stopped cleanly. I started the service again and verified that Port 80 was listening and the website returned `200 OK`.

**Troubleshooting flow:** **Verify → Fail → Diagnose → Fix → Verify**

### 30-Second Demo Version

> I installed and operated an Nginx web server on Linux, verified the service and HTTP connectivity, created a controlled outage by stopping Nginx, diagnosed the failure using systemctl, ss, and journalctl, restored the service, and verified recovery with Port 80 listening and HTTP 200 OK.

## 1. Establish the SysAdmin Context

I confirmed the account and host before making changes:

```bash
cd ~
pwd
whoami
hostname
```

Observed:

- Home directory: `/home/dev`
- User: `dev`
- Host: `msi-aegis-zs2`

I also checked whether Nginx was already installed:

```bash
nginx -v
```

Result: Nginx was not installed.

## 2. Install the Web Server

I refreshed package metadata and installed Nginx:

```bash
sudo apt update
sudo apt install nginx -y
```

The installation completed successfully and registered `nginx.service` with systemd.

## 3. Verify the Running Service

I checked the service:

```bash
systemctl status nginx --no-pager
```

Observed:

```text
Active: active (running)
```

I then verified that Nginx was listening for HTTP traffic:

```bash
sudo ss -tulnp | grep :80
```

Observed TCP listeners on Port 80 for IPv4 and IPv6.

Finally, I tested the service as a client:

```bash
curl -I http://localhost
```

Observed:

```text
HTTP/1.1 200 OK
Server: nginx/1.28.3 (Ubuntu)
```

This established a known-good baseline before troubleshooting.

## 4. Create a Controlled Outage

To simulate a service incident safely, I stopped Nginx:

```bash
sudo systemctl stop nginx
curl -I http://localhost
```

The HTTP request failed:

```text
curl: (7) Failed to connect to localhost port 80 after 0 ms: Could not connect to server
```

## 5. Diagnose the Failure

### Check service state

```bash
systemctl status nginx --no-pager
```

Observed:

```text
Active: inactive (dead)
```

### Check the network port

```bash
sudo ss -tulnp | grep :80
```

There was no output, confirming that no process was listening on Port 80.

### Check service logs

```bash
sudo journalctl -u nginx --since "10 minutes ago" --no-pager
```

The journal showed that Nginx had been stopped and deactivated successfully.

**Root cause:** The HTTP service was unavailable because Nginx was stopped. The evidence did not indicate a crash; the service had been cleanly deactivated.

## 6. Restore Service

I started Nginx again:

```bash
sudo systemctl start nginx
systemctl status nginx --no-pager
```

Observed:

```text
Active: active (running)
```

## 7. Verify Recovery

I did not treat a successful start command as sufficient proof of recovery. I verified both the network listener and application response:

```bash
sudo ss -tulnp | grep :80
curl -I http://localhost
```

Final results:

- Port 80: `LISTEN`
- Nginx: `active (running)`
- HTTP response: `HTTP/1.1 200 OK`

The service was fully restored.

## Troubleshooting Method Learned

The incident demonstrated a repeatable SysAdmin troubleshooting sequence:

1. Reproduce and confirm the user-visible failure.
2. Check the service state.
3. Check whether the expected network port is listening.
4. Review service logs for evidence.
5. Identify the root cause from the evidence.
6. Apply the repair.
7. Re-test the service, port, and client response.

This avoids guessing and provides evidence at each layer.

## Skills Demonstrated

- Linux package management
- Nginx web-server installation
- systemd service administration
- Service-state verification
- TCP listening-port inspection
- HTTP validation with `curl`
- Controlled incident simulation
- Linux journal/log inspection
- Root-cause troubleshooting
- Service restoration
- Post-recovery verification

## Completion

This lab provides hands-on evidence of taking on a SysAdmin role, standing up and operating a Linux web service, diagnosing a service outage using system and network evidence, restoring the service, and validating successful recovery.
