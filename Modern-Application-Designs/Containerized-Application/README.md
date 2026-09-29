# Containerized Application — Hands-On Docker Lab

**Competency:** Architecting for DevSecOps / Microservices  
**Requirement:** Demonstrate ability to architect and develop a containerized application.  
**Lab date:** September 29, 2026  
**Environment:** Ubuntu on WSL2 with Docker Desktop integration  
**Application:** Static Nginx web application packaged in Docker

## Excel Competency Summary

Built and validated a containerized web application using Docker. Created the application content and Dockerfile, built a versioned Docker image, launched the container with host-to-container port mapping, verified the running container, and confirmed successful HTTP access with an HTTP 200 response.

## Demo Summary / Presentation Talking Points

For this competency, I containerized a small web application using Docker and Nginx. I created a simple HTML application, wrote a Dockerfile based on the lightweight `nginx:alpine` image, and built a versioned image named `dso-tap-web:v1`.

I then launched the image as a running container, mapped host Port 8080 to container Port 80, verified the container with `docker ps`, and tested the application with `curl`. The application returned the expected HTML content and an HTTP `200 OK` response.

This demonstrated the full container workflow from application source to Docker image to running service.

**Container workflow:** **App → Dockerfile → Build Image → Run Container → Map Port → Verify**

### 30-Second Demo Version

> I created a small Nginx web application, wrote a Dockerfile, built a versioned Docker image, and ran it as a container. I mapped host Port 8080 to container Port 80, verified the container was running, and tested the application with curl. The container returned the expected web page and HTTP 200 OK.

## 1. Verify Docker Environment

I first confirmed Docker was available inside Ubuntu/WSL:

```bash
docker --version
docker info --format '{{.ServerVersion}}'
```

Observed:

```text
Docker version 29.5.3
29.5.3
```

This confirmed both the Docker CLI and Docker Engine were available through WSL integration.

## 2. Create the Application

I created an isolated lab workspace:

```bash
cd ~
mkdir -p dso-tap-container-lab
cd dso-tap-container-lab
```

I then created `index.html`:

```html
<!DOCTYPE html>
<html>
<head>
  <title>DSO-TAP Container Lab</title>
</head>
<body>
  <h1>DSO-TAP Containerized Application</h1>
  <p>This page is running inside a Docker container.</p>
</body>
</html>
```

## 3. Create the Dockerfile

I created a Dockerfile:

```dockerfile
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
```

This defined:

- Base image: `nginx:alpine`
- Application content: custom `index.html`
- Application port: TCP 80

## 4. Build the Docker Image

I built a versioned image:

```bash
docker build -t dso-tap-web:v1 .
```

The build completed successfully.

I verified the image:

```bash
docker images dso-tap-web
```

Observed:

```text
IMAGE            ID             DISK USAGE   CONTENT SIZE
dso-tap-web:v1   ce861637e9e3       93.6MB         26.3MB
```

## 5. Run the Container

Because the host Nginx service was already using Port 80, I mapped a different host port to the container:

```bash
docker run -d --name dso-tap-web -p 8080:80 dso-tap-web:v1
```

The container started successfully.

I verified the running container:

```bash
docker ps
```

Observed:

```text
dso-tap-web:v1 ... Up ... 0.0.0.0:8080->80/tcp ... dso-tap-web
```

This demonstrated the mapping:

```text
Host Port 8080 → Container Port 80
```

## 6. Validate the Containerized Application

I requested the application directly:

```bash
curl http://localhost:8080
```

The container returned the expected HTML:

```text
DSO-TAP Containerized Application
This page is running inside a Docker container.
```

I then checked the HTTP headers:

```bash
curl -I http://localhost:8080
```

Observed:

```text
HTTP/1.1 200 OK
Server: nginx/1.31.6
```

This confirmed that the application was successfully running and reachable from outside the container through the configured port mapping.

## Architecture

```text
Client / curl
     |
     v
Host Port 8080
     |
     v
Docker Port Mapping
     |
     v
Container Port 80
     |
     v
Nginx inside Container
     |
     v
index.html
```

## Skills Demonstrated

- Docker Desktop and WSL integration
- Docker CLI and Engine validation
- Application packaging
- Dockerfile authoring
- Container image creation
- Versioned image tagging
- Container launch
- Host-to-container port mapping
- Running-container inspection
- HTTP application validation
- Containerized application architecture

## Completion

This lab provides hands-on evidence of architecting and developing a containerized application from source content through Docker image creation, container runtime configuration, network port mapping, and successful application validation.
