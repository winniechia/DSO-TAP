# Build a Container Following Best Practices

## Competency
**Demonstrate ability to build a container following best practices.**

## Objective
Build and validate a small Nginx web application image using a non-root base image, a minimal build context, explicit file ownership, a documented application port, and an application health check.

## Lab Environment
- Ubuntu on WSL2, integrated with Docker Desktop
- Docker Client/Engine: 29.5.3
- Docker Desktop: 4.79.0
- Working directory: `~/dso-tap-container-lab`
- Application: static HTML served by Nginx

This is an isolated training lab; it does not modify the Love Fills Memory application.

## Dockerfile.best-practices

```dockerfile
FROM nginxinc/nginx-unprivileged:alpine

COPY --chown=101:101 index.html /usr/share/nginx/html/index.html

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1:8080/ || exit 1
```

### .dockerignore

```gitignore
.git
.gitignore
*.log
*.tmp
.env
.env.*
node_modules
__pycache__
README.md
```

## Build and Run

```bash
cd ~/dso-tap-container-lab
docker build -f Dockerfile.best-practices -t dso-tap-web:best-practices .
docker run -d --name dso-tap-web-best -p 8082:8080 dso-tap-web:best-practices
```

## Verified Hands-on Evidence

| Verification | Command / evidence | Observed result |
| --- | --- | --- |
| Docker connectivity | `docker version` | Client and Server both available, version 29.5.3 |
| Build completed | `docker build -f Dockerfile.best-practices -t dso-tap-web:best-practices .` | `[+] Building ... (7/7) FINISHED`; image tagged `dso-tap-web:best-practices` |
| Build context filtering | Build output | `.dockerignore` loaded; context transfer reported as 32 B |
| Image file ownership instruction | Build output | `COPY --chown=101:101 index.html ...` executed |
| Container running | `docker ps --filter name=dso-tap-web-best` | `Up About a minute (healthy)` |
| Published port | `docker ps --filter name=dso-tap-web-best` | Host `8082` mapped to container `8080/tcp` |
| Runtime user | `docker exec dso-tap-web-best id` | `uid=101(nginx) gid=101(nginx) groups=101(nginx)` |
| External HTTP response | `curl -I http://localhost:8082` | `HTTP/1.1 200 OK`; `Server: nginx/1.31.7` |
| Image user configuration | `docker image inspect ...` | `User=101` |
| Image exposed port | `docker image inspect ...` | `Ports={"8080/tcp":{}}` |
| Image health check | `docker image inspect ...` | `wget -q -O /dev/null http://127.0.0.1:8080/ || exit 1`; interval 30 s; timeout 3 s; start period 5 s; retries 3 |

## Why These Practices Matter

1. **Purpose-built non-root base:** `nginxinc/nginx-unprivileged:alpine` runs Nginx without requiring root privileges; runtime evidence confirms UID 101.
2. **Explicit file ownership:** `COPY --chown=101:101` assigns ownership of the copied HTML file to the application user.
3. **Smaller, safer build context:** `.dockerignore` excludes Git metadata, temporary files, environment files, and unrelated dependency directories from the Docker build context. This does not by itself prove a smaller final image.
4. **Documented service port:** `EXPOSE 8080` describes the container's listening port; `-p 8082:8080` actually publishes it on the host.
5. **Operational health monitoring:** `HEALTHCHECK` tests Nginx locally, and the running container reported `healthy`.
6. **Readable image tag:** `best-practices` distinguishes this training build from earlier image variants.

**Limitations / further hardening:** The base uses a moving `:alpine` tag. For stricter reproducibility, pin a vetted version or digest and adopt a regular update process. This lab did not perform vulnerability scanning, SBOM generation, or image signing; do not interpret the checks above as proof of those controls.

## Competency Interview Answer

**Question: What are Docker container build best practices?**

Docker container build best practices include using a minimal and trusted base image, running applications as a non-root user, excluding unnecessary files with `.dockerignore`, setting proper file ownership, implementing health checks, using controlled image versions, and validating the image before deployment.

In my hands-on lab, I applied these practices to an Nginx container and verified that it ran as UID 101, passed its health check, and returned HTTP 200.

## 30-Second Demo Summary

> I built a Docker image for a static Nginx application using an unprivileged Alpine-based image. I reduced the build context with a .dockerignore file, copied the application with ownership assigned to UID 101, exposed port 8080, and added an HTTP health check. The build finished successfully. I started the container with host port 8082, confirmed Docker reported it healthy, verified it runs as nginx UID 101 rather than root, and received HTTP 200 from the host. Image inspection also confirmed the configured user, exposed port, and health check.

## Excel Competency Summary

| Field | Entry |
| --- | --- |
| Competency | Demonstrate ability to build a container following best practices |
| Status | Completed — hands-on build and runtime verification passed |
| Tools | Docker Desktop, Docker Engine, Ubuntu WSL2, Nginx |
| Evidence | Successful image build; .dockerignore loaded; UID 101; healthy container; HTTP 200; image inspection |
| Image | `dso-tap-web:best-practices` |
| Container | `dso-tap-web-best` |
| Host / Container Ports | `8082:8080` |
| Repository Evidence | `Modern-Application-Designs/Container-Build-Best-Practices/README.md` |
| Follow-up | Optional: pin base image digest; scan dependencies/image; generate SBOM; sign image |

## Final Checkpoint

- [x] Hands-on image build completed
- [x] Running container verified
- [x] Runtime non-root identity verified
- [x] HTTP 200 verified from host
- [x] HEALTHCHECK reported healthy
- [x] Image configuration inspected
- [x] English-only GitHub documentation prepared
- [x] 30-second demo summary included
- [x] Excel competency summary included

**Outcome:** The container-build best-practices competency is supported by observed build, configuration, and runtime evidence.
