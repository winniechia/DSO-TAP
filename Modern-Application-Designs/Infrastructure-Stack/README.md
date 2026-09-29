# Effective Infrastructure Stack — Integrated Hands-On Validation

**Competency:** Modern Application Designs and Running on Infrastructure Platforms — Infrastructure Stack  
**Requirement:** Demonstrate ability to establish and maintain the elements of an effective infrastructure stack for a small development team.  
**Lab date:** September 29, 2026  
**Environment:** Ubuntu on WSL2, host `msi-aegis-zs2`

## Excel Competency Summary

Established and validated an integrated Linux infrastructure stack for a small development team, including an Nginx application service, network connectivity, storage, operational logging, tested backup/recovery, and role-based access control. Performed health checks across each layer and verified that the application was running, Port 80 was listening, HTTP returned 200 OK, storage had available capacity, service events were logged, a backup archive was present, and protected resources were restricted to the appropriate role.

## Demo Summary / Presentation Talking Points

For this competency, I validated the infrastructure as an integrated stack rather than treating server, network, storage, operations, and security as isolated components.

The stack consisted of a Linux server running Nginx, HTTP networking on Port 80, filesystem storage, systemd journal logging, an application backup/recovery process, and Linux group-based access control.

I performed a health check across every layer. Nginx was active, Port 80 was listening, the application returned HTTP 200 OK, storage capacity was healthy, Nginx service events were available through `journalctl`, the previously tested application backup remained available, and the protected development-team resource was owned by the Developers role with restrictive permissions.

### 30-Second Demo Version

> I established and validated a small-team Linux infrastructure stack consisting of an Nginx application server, network service on Port 80, filesystem storage, operational logging, backup/recovery, and RBAC security. I checked each layer individually and verified that the application was running and reachable, storage and logs were healthy, backup evidence was present, and access to the protected team resource was restricted to the Developers role.

## Stack Architecture

```text
Small Development Team
        |
        v
Linux Server / WSL2
        |
        v
Nginx Application Service
        |
        +---- Network / TCP Port 80 / HTTP
        |
        +---- Filesystem Storage
        |
        +---- systemd / journalctl Logging
        |
        +---- Application Backup and Recovery
        |
        +---- RBAC / Linux Groups and Permissions
```

## 1. Server and Application Layer

I verified the Nginx service:

```bash
systemctl status nginx --no-pager
```

Observed:

```text
Loaded: loaded
Active: active (running)
Main PID: 2543
Memory: 18.7M
```

This confirmed that the web application service was operational.

## 2. Network Layer

I verified that Nginx was listening on TCP Port 80:

```bash
sudo ss -tulnp | grep :80
```

Observed listeners on:

```text
0.0.0.0:80
[::]:80
```

I then tested the HTTP service:

```bash
curl -I http://localhost
```

Observed:

```text
HTTP/1.1 200 OK
Server: nginx/1.28.3 (Ubuntu)
```

This verified both the listening network service and successful application response.

## 3. Storage Layer

I checked filesystem capacity:

```bash
df -h /
```

Observed:

```text
Filesystem  Size   Used  Avail  Use%
/dev/sdd    1007G  6.5G  950G   1%
```

I also measured the web-content directory:

```bash
du -sh /var/www
```

Observed:

```text
12K /var/www
```

The server had ample available storage for the current workload.

## 4. Logging and Operational Visibility

I reviewed recent Nginx service events:

```bash
sudo journalctl -u nginx -n 5 --no-pager
```

The journal showed the controlled stop and subsequent successful start of Nginx:

```text
Stopping nginx.service...
nginx.service: Deactivated successfully.
Stopped nginx.service...
Starting nginx.service...
Started nginx.service...
```

This confirmed that operational service events were recorded and available for troubleshooting.

## 5. Backup and Recovery Layer

I verified that the application backup created during the backup/recovery lab remained available:

```bash
ls -lh ~/dso-tap-backup-lab/backups
```

Observed:

```text
app-20260929-113831.tar.gz
```

The separate backup lab had already tested this process by inspecting the archive, restoring application data, and verifying matching SHA-256 checksums between the original and restored files. The integrated stack check therefore verified continued availability of the backup without unnecessarily repeating the completed recovery exercise.

## 6. Security and RBAC Layer

I verified the Developers role:

```bash
getent group developers
```

Observed:

```text
developers:x:1002:alice
```

I then checked the protected team resource:

```bash
sudo ls -ld /srv/dev-team
```

Observed:

```text
drwxrwx--- 2 root developers ... /srv/dev-team
```

The directory is owned by the `developers` group and uses mode `770`, providing access to the owner and Developers role while denying access to others.

The separate RBAC lab also verified enforcement by allowing Alice, a Developer, to create a file while denying Bob, an Auditor, and the unassigned `dev` account.

## Integrated Health Check

| Stack Layer | Validation | Result |
| --- | --- | --- |
| Server | Linux environment operational | Pass |
| Application | Nginx active and running | Pass |
| Network | TCP Port 80 listening | Pass |
| HTTP | HTTP 200 OK | Pass |
| Storage | 950 GB available; 1% filesystem use | Pass |
| Application data | Web content present under `/var/www` | Pass |
| Logging | Nginx events visible in `journalctl` | Pass |
| Backup / Recovery | Backup archive available; recovery previously verified | Pass |
| Security / RBAC | Developers role and protected resource verified | Pass |

## Maintenance Approach

An effective infrastructure stack is not complete simply because it was installed once. It must remain observable, recoverable, appropriately sized, and access-controlled.

The maintenance approach demonstrated across these labs includes:

- Check service health with `systemctl`.
- Check listening services and network exposure with `ss`.
- Test application responses with `curl`.
- Monitor storage capacity with `df` and `du`.
- Review operational events with `journalctl`.
- Maintain and test application backups.
- Apply least-privilege access using groups and filesystem permissions.
- Measure workload demand and right-size resources rather than over-provisioning.

## Related Hands-On Evidence

This integrated validation builds on the detailed labs already completed in this repository:

- Servers, Networks, and Storage
- SysAdmin Web Server Troubleshooting
- Application Backup and Restore
- Linux RBAC
- Server Sizing
- Linux Logging

Together, these exercises demonstrate both establishment and ongoing maintenance of the infrastructure elements needed by a small development team.

## Skills Demonstrated

- Integrated infrastructure validation
- Linux server administration
- Web service operation
- TCP/IP service validation
- HTTP health checking
- Storage capacity management
- Operational logging
- Backup and recovery
- RBAC and least privilege
- Troubleshooting readiness
- Infrastructure maintenance
- Capacity planning

## Completion

This lab demonstrates an effective small-team infrastructure stack by integrating and validating server, application, network, storage, logging, backup/recovery, security, and maintenance practices as one operational system.
