# Container Security Best Practices — Hands-On Hardening Lab

**Competency:** Architecting for DevSecOps / Microservices  
**Requirement:** Demonstrate ability to apply container security best practices to container development.  
**Lab date:** September 29, 2026  
**Environment:** Ubuntu on WSL2 with Docker Desktop integration  
**Application:** Nginx web application

## Excel Competency Summary

Applied container security best practices by identifying that the original Docker container ran as root, rebuilding the application with an unprivileged Nginx base image, running the hardened container as a non-root user, and verifying that the application still functioned correctly with HTTP 200 OK.

## Demo Summary / Presentation Talking Points

For this competency, I assessed the security posture of my existing Dockerized web application and found that the original container was running as `root`.

I then hardened the image using `nginxinc/nginx-unprivileged:alpine`, which is designed to run as a non-root user. I built a separate secure image, launched it on a different host port, and verified that the process inside the container ran as the `nginx` user with UID 101 instead of UID 0.

Finally, I confirmed that the hardened application still returned HTTP `200 OK`, demonstrating that least-privilege hardening did not break the service.

**Security flow:** **Assess → Identify Risk → Harden → Verify Identity → Verify Functionality**

### 30-Second Demo Version

> I inspected my original Docker container and found that it was running as root. I then rebuilt the application using an unprivileged Nginx image, launched the hardened container, and verified that it ran as the nginx user with UID 101 instead of root. I also confirmed the web application still returned HTTP 200 OK, demonstrating least privilege without breaking functionality.

## 1. Assess the Original Container

I inspected the existing container:

```bash
docker exec dso-tap-web whoami
docker exec dso-tap-web id
docker inspect dso-tap-web --format 'ConfiguredUser={{.Config.User}}'
```

Observed:

```text
root
uid=0(root) gid=0(root)
ConfiguredUser=
```

This showed that the original container did not explicitly configure a non-root user and was running as root.

## 2. Security Risk Identified

Running a container as root gives the application more privilege inside the container than it normally needs.

The security objective was therefore to apply **least privilege** by running the web service as a non-root user.

## 3. Create a Hardened Dockerfile

I created `Dockerfile.secure`:

```dockerfile
FROM nginxinc/nginx-unprivileged:alpine

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 8080
```

The unprivileged Nginx image uses a non-root execution model and listens on an unprivileged port.

## 4. Build the Hardened Image

I built a separate secure image:

```bash
docker build -f Dockerfile.secure -t dso-tap-web:secure .
```

The build completed successfully.

I then compared the available application images:

```bash
docker images dso-tap-web
```

Observed:

```text
dso-tap-web:secure   82.2MB disk usage   23.3MB content
dso-tap-web:v1       93.6MB disk usage   26.3MB content
```

The smaller image size was a side benefit, but the primary security improvement was the non-root runtime.

## 5. Run the Hardened Container

I launched the secure image with a separate host port:

```bash
docker run -d --name dso-tap-web-secure -p 8081:8080 dso-tap-web:secure
```

The secure container was running as:

```text
dso-tap-web-secure
0.0.0.0:8081 -> 8080/tcp
```

## 6. Verify Non-Root Execution

I inspected the identity inside the hardened container:

```bash
docker exec dso-tap-web-secure whoami
docker exec dso-tap-web-secure id
```

Observed:

```text
nginx
uid=101(nginx) gid=101(nginx) groups=101(nginx)
```

This confirmed the container was no longer running as root.

## 7. Verify Application Functionality

I tested the hardened web service:

```bash
curl -I http://localhost:8081
```

Observed:

```text
HTTP/1.1 200 OK
Server: nginx/1.31.6
```

This verified that the security improvement did not break the application.

## Before vs. After

| Area | Original Container | Hardened Container |
| --- | --- | --- |
| Image | `dso-tap-web:v1` | `dso-tap-web:secure` |
| Runtime user | `root` | `nginx` |
| UID | `0` | `101` |
| Container port | `80` | `8080` |
| Host port | `8080` | `8081` |
| HTTP response | `200 OK` | `200 OK` |
| Least privilege | No | Yes |

## Security Principle Demonstrated

The key principle demonstrated was **least privilege**:

```text
Application needs web-serving permissions
            |
            v
Do not run as root unless required
            |
            v
Use a non-root runtime identity
            |
            v
Verify application still functions
```

## Additional Container Security Best Practices

Beyond the hands-on control demonstrated in this lab, good container security practice also includes:

- Use minimal and trusted base images.
- Pin and review image versions where practical.
- Keep images and dependencies patched.
- Avoid storing secrets in images or Dockerfiles.
- Scan images for known vulnerabilities.
- Drop unnecessary Linux capabilities.
- Use read-only filesystems where practical.
- Limit exposed ports.
- Apply resource limits.
- Run containers as non-root whenever possible.

## Skills Demonstrated

- Container security assessment
- Runtime identity inspection
- Root-vs-non-root comparison
- Least-privilege hardening
- Secure base-image selection
- Hardened image build
- Non-root container execution
- Port mapping
- Post-hardening functional validation

## Completion

This lab provides hands-on evidence of applying container security best practices by identifying an over-privileged runtime, rebuilding the application with a non-root image, verifying the new runtime identity, and confirming that the hardened application continued to operate successfully.
