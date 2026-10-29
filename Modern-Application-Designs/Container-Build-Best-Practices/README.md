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

## Learning Review — Steps Taken and Lessons Learned

### Steps We Took (and Why)

| Step | Action | Why it mattered |
| --- | --- | --- |
| 1 | Checked Docker Desktop / WSL integration using `docker version`. | Confirmed the Docker client and engine were available after a temporary WSL integration issue. |
| 2 | Returned to `~/dso-tap-container-lab`. | Kept training changes separate from the Love Fills Memory project. |
| 3 | Created `.dockerignore` to exclude Git metadata, environment files, logs, and unrelated dependencies. | Reduced unnecessary build context and the risk of accidentally including sensitive files. |
| 4 | Wrote `Dockerfile.best-practices` using `nginxinc/nginx-unprivileged:alpine`. | Selected a small, non-root-oriented Nginx base image. |
| 5 | Added `COPY --chown=101:101`, `EXPOSE 8080`, and an HTTP `HEALTHCHECK`. | Set file ownership, documented the service port, and defined a runtime health probe. |
| 6 | Built `dso-tap-web:best-practices`. | Verified the Dockerfile could produce an image successfully. |
| 7 | Ran `dso-tap-web-best` with `-p 8082:8080`. | Published the container service on an unused host port. |
| 8 | Checked `docker ps`, `docker exec ... id`, and `curl -I`. | Confirmed `healthy`, non-root UID 101, and external HTTP 200. |
| 9 | Inspected image configuration. | Verified `User=101`, exposed port `8080/tcp`, and the configured health check. |

### Commands Explained

| Command | Purpose |
| --- | --- |
| `docker version` | Check client and server connectivity. |
| `docker build -f Dockerfile.best-practices -t dso-tap-web:best-practices .` | Build a named image from the specified Dockerfile and current build context. |
| `docker run -d --name dso-tap-web-best -p 8082:8080 dso-tap-web:best-practices` | Start a detached container and map host port 8082 to container port 8080. |
| `docker ps --filter name=dso-tap-web-best` | Check running status, health, and port publishing. |
| `docker exec dso-tap-web-best id` | Verify the actual runtime user. |
| `curl -I http://localhost:8082` | Check external HTTP response headers. |
| `docker image inspect dso-tap-web:best-practices` | Examine the image's user, exposed ports, and health-check configuration. |

### Problem Encountered and Resolution

**Problem:** Docker was initially unavailable from the Ubuntu WSL2 terminal even though Docker Desktop's Ubuntu integration was enabled.

**Resolution:** Exited Ubuntu, ran `wsl --shutdown` from **Windows PowerShell** (not from inside Ubuntu), reopened Ubuntu, and confirmed that `docker version` displayed both Client and Server. Then resumed the isolated lab.

**Why this matters:** When a command is missing, distinguish between an application problem, an unavailable CLI, and an integration issue before modifying files or reinstalling software.

### Lessons Learned

1. A successful image build does **not** prove the container runs correctly; test runtime behavior separately.
2. A non-root base image and `COPY --chown` support least privilege; verify the actual runtime UID.
3. `.dockerignore` filters the **build context**; it does not automatically guarantee a smaller final image.
4. `EXPOSE` is image metadata; `docker run -p` publishes the service to the host.
5. A configured `HEALTHCHECK` must be observed at runtime rather than assumed to work.
6. Use meaningful image tags, but pin a vetted version or digest when strict reproducibility is required.
7. Keep hands-on training isolated from unrelated production or personal projects.

### How to Explain It to an Evaluator

**Plain-English explanation:** I built an Nginx container using an unprivileged Alpine-based image, excluded unnecessary files with `.dockerignore`, assigned ownership to UID 101, declared the service port, and added a health check. I then built and ran the image, checked that Docker reported it healthy, verified that the process ran as a non-root user, and confirmed HTTP 200 from the host. I also inspected the image configuration to verify the settings.

**Memory aid:** **Build → Run → Check User → Check Health → Test HTTP → Inspect Image.**

**Key distinction:** A container that *builds* is not necessarily a container that *works securely and reliably*.

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
