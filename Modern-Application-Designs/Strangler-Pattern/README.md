# Strangler Pattern — Hands-On Migration Lab

**Competency:** Architecting for DevSecOps / Microservices  
**Requirement:** Explain and demonstrate ability to implement the Strangler Pattern on an existing project.  
**Lab date:** September 29, 2026  
**Environment:** Ubuntu on WSL2, Nginx, Docker

## Excel Competency Summary

Implemented and validated the Strangler Pattern by placing an Nginx routing layer in front of legacy and modern application paths. Kept the existing legacy application operational while routing a separate path to a Dockerized Nginx application, then verified both implementations through the same front-door server on Port 8090.

## Demo Summary / Presentation Talking Points

For this competency, I demonstrated an incremental modernization strategy using the Strangler Pattern.

I kept a legacy web application running while introducing a modern Dockerized application alongside it. I configured Nginx as the routing layer on Port 8090. Requests to `/legacy/` were served by the existing legacy application, while requests to `/modern/` were proxied to the containerized application running on host Port 8080.

I validated the Nginx configuration before applying it, reloaded Nginx, and used `curl` to prove that both legacy and modern routes were available simultaneously.

This demonstrates how an existing application can remain operational while functionality is gradually migrated to newer services instead of requiring a high-risk, all-at-once replacement.

### 30-Second Demo Version

> I implemented the Strangler Pattern by keeping a legacy application available while adding a modern Dockerized service beside it. Nginx acted as the front-door router on Port 8090. The `/legacy/` path continued to serve the existing application, while `/modern/` routed to the new containerized service on Port 8080. I tested both paths successfully, demonstrating how functionality can be migrated incrementally without immediately replacing the entire legacy system.

## 1. Starting State

The modern containerized application from the previous lab was already running:

```text
dso-tap-web:v1
Host Port 8080 -> Container Port 80
Container name: dso-tap-web
```

The existing Love Fills Memory PostgreSQL container was not modified during this lab.

## 2. Create a Legacy Application

I created a simple legacy application:

```bash
sudo mkdir -p /var/www/strangler-legacy
```

The legacy application content was stored in:

```text
/var/www/strangler-legacy/index.html
```

Content:

```html
<h1>Legacy Application</h1><p>This is the existing legacy service.</p>
```

I verified the file with:

```bash
cat /var/www/strangler-legacy/index.html
```

## 3. Configure the Routing Layer

I created:

```text
/etc/nginx/sites-available/strangler-demo
```

with the following routing configuration:

```nginx
server {
    listen 8090;
    server_name localhost;

    location /legacy/ {
        alias /var/www/strangler-legacy/;
        index index.html;
    }

    location /modern/ {
        proxy_pass http://localhost:8080/;
    }
}
```

This created one front door with two application paths:

```text
Client
  |
  v
Nginx Router :8090
  |
  +-- /legacy/ --> Legacy application
  |
  +-- /modern/ --> Dockerized application :8080
```

## 4. Validate Before Applying

Before enabling the configuration, I tested it:

```bash
sudo nginx -t
```

Observed:

```text
syntax is ok
test is successful
```

This demonstrated a safe configuration-change practice: validate first, then apply.

## 5. Enable and Reload

I enabled the site:

```bash
sudo ln -s /etc/nginx/sites-available/strangler-demo /etc/nginx/sites-enabled/strangler-demo
```

Then safely reloaded Nginx:

```bash
sudo systemctl reload nginx
```

## 6. Verify the Legacy Route

I tested:

```bash
curl http://localhost:8090/legacy/
```

Observed:

```html
<h1>Legacy Application</h1><p>This is the existing legacy service.</p>
```

This confirmed the legacy functionality remained available.

## 7. Verify the Modern Route

I tested:

```bash
curl http://localhost:8090/modern/
```

Observed application content included:

```text
DSO-TAP Containerized Application
This page is running inside a Docker container.
```

This confirmed that the Nginx routing layer successfully forwarded the modern route to the Dockerized application.

## Architecture

```text
                         +----------------------+
                         | Client / curl        |
                         +----------+-----------+
                                    |
                                    v
                         +----------------------+
                         | Nginx Router :8090   |
                         +----------+-----------+
                                    |
                   +----------------+----------------+
                   |                                 |
                   v                                 v
            /legacy/                           /modern/
                   |                                 |
                   v                                 v
      Legacy static application             proxy_pass :8080
      /var/www/strangler-legacy                     |
                                                     v
                                            Docker container
                                            dso-tap-web:v1
                                            Container Port 80
```

## Why This Is the Strangler Pattern

The legacy application was not removed or rewritten. Instead, a routing layer allowed the legacy and modern implementations to operate side-by-side.

This supports incremental migration:

```text
Existing system
      |
Add routing layer
      |
Move selected functionality to modern service
      |
Continue migrating routes/features over time
      |
Retire legacy implementation when no longer needed
```

The lab represents the migration stage where legacy and modern functionality coexist.

## Skills Demonstrated

- Strangler Pattern architecture
- Incremental application modernization
- Legacy and modern service coexistence
- Nginx path-based routing
- Reverse proxy configuration
- Dockerized service integration
- Safe Nginx configuration validation
- Service reload
- Route verification with curl
- DevSecOps migration thinking

## Completion

This lab provides hands-on evidence of implementing the Strangler Pattern. A legacy application remained operational while a modern Dockerized application was introduced behind the same Nginx routing layer. Both routes were tested successfully, demonstrating an incremental migration approach rather than a complete application replacement.
