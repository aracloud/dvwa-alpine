# DVWA Alpine

![Docker](https://img.shields.io/badge/Docker-ready-2496ED?logo=docker&logoColor=white)
![Alpine Linux](https://img.shields.io/badge/Alpine%20Linux-based-0D597F?logo=alpinelinux&logoColor=white)
![DVWA](https://img.shields.io/badge/DVWA-vulnerable-red)
![License](https://img.shields.io/badge/License-GPLv3-blue)

**Lightweight DVWA container based on Alpine Linux — built for security demonstrations, testing and lab environments.**

This project provides a lightweight, ready-to-use Docker image of **Damn Vulnerable Web Application (DVWA)**.

The container includes an **initialized MySQL database**, so no separate database container or manual database setup is required.

> ⚠️ **DVWA is intentionally vulnerable. This container is for demonstration, testing and lab environments only. Do not expose it directly to the Internet.**

---

## Features

- Lightweight Alpine Linux based container
- DVWA pre-installed
- Nginx + PHP
- MySQL database included
- Database initialized automatically
- No separate database container required
- Ready to run with Docker
- Available via GitHub Container Registry
- Suitable for WAF and reverse-proxy demonstrations
- Suitable for load-balancer demonstrations
- Useful for security testing and training environments

---

## Quick Start

### Pull the image

```bash
docker pull ghcr.io/aracloud/dvwa-alpine:latest
```

### Start the container

```bash
docker run -dit \
  --name dvwa \
  -p 8080:80 \
  ghcr.io/aracloud/dvwa-alpine:latest
```

DVWA is now available at:

```text
http://localhost:8080
```

If you want to expose it directly on port 80:

```bash
docker run -dit \
  --name dvwa \
  -p 80:80 \
  ghcr.io/aracloud/dvwa-alpine:latest
```

---

## Login

The database is already initialized when the container starts.

Default credentials:

| Username | Password |
|----------|----------|
| `admin` | `password` |

After starting the container, open:

```text
http://<server-ip>:8080
```

and log in with the credentials above.

---

## Docker Compose

A minimal `compose.yml`:

```yaml
services:
  dvwa:
    image: ghcr.io/aracloud/dvwa-alpine:latest
    container_name: dvwa
    ports:
      - "8080:80"
    restart: unless-stopped
```

Start DVWA:

```bash
docker compose up -d
```

Check the container:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f
```

Stop DVWA:

```bash
docker compose down
```

---

## F5 Distributed Cloud / WAF Demo

This container is particularly useful as a backend for **F5 Distributed Cloud (F5 XC)**, reverse-proxy and WAF demonstrations.

A typical deployment looks like this:

```text
                         Client
                           │
                           │ HTTPS
                           ▼
                  ┌─────────────────┐
                  │     F5 XC       │
                  │                 │
                  │  Load Balancer  │
                  │      + WAF      │
                  └────────┬────────┘
                           │
                           │ HTTP
                           ▼
                  ┌─────────────────┐
                  │  Customer DC    │
                  │                 │
                  │  Docker Host    │
                  │       │         │
                  │       ▼         │
                  │   ┌─────────┐   │
                  │   │  DVWA   │   │
                  │   │ Alpine  │   │
                  │   └─────────┘   │
                  └─────────────────┘
```

The backend can be used to demonstrate:

- Web Application Firewall protection
- HTTP request inspection
- Reverse proxy behavior
- Load balancing
- Source IP forwarding
- HTTP header manipulation
- `X-Forwarded-For`
- `X-Forwarded-Host`
- `X-Forwarded-Proto`
- Backend identification
- Attack detection
- Security policy enforcement

---

## Backend Information

The login page can display information received by the backend server.

For example:

```text
Server Name:       dvwa
Server IP:         10.10.20.15
Client/Proxy IP:   10.10.20.15
X-Forwarded-For:   192.0.2.10
```

This is useful when DVWA is placed behind a reverse proxy or F5 XC.

It allows you to demonstrate the difference between:

- Backend server IP
- TCP source IP seen by the backend
- Original client IP
- HTTP forwarding headers

For example:

```text
Client
  │
  │ Source IP: 192.0.2.10
  │
  ▼
F5 XC
  │
  │ Source IP: F5 XC
  │ X-Forwarded-For: 192.0.2.10
  │
  ▼
DVWA Backend
```

This makes the container useful for demonstrating how client information is propagated through a proxy/load-balancer architecture.

---

## Build From Source

Clone the repository:

```bash
git clone https://github.com/aracloud/dvwa-alpine.git
cd dvwa-alpine
```

Build the image:

```bash
docker build -t dvwa-alpine .
```

Run the locally built image:

```bash
docker run -dit \
  --name dvwa \
  -p 8080:80 \
  dvwa-alpine
```

---

## Updating the Container

Pull the latest image:

```bash
docker pull ghcr.io/aracloud/dvwa-alpine:latest
```

Remove the existing container:

```bash
docker rm -f dvwa
```

Start the updated container:

```bash
docker run -dit \
  --name dvwa \
  -p 8080:80 \
  ghcr.io/aracloud/dvwa-alpine:latest
```

If you are using Docker Compose:

```bash
docker compose pull
docker compose up -d
```

---

## Container Architecture

The container provides the complete application stack required to run DVWA:

```text
┌─────────────────────────────────────┐
│          dvwa-alpine                │
│                                     │
│  ┌─────────────┐                    │
│  │    Nginx    │ :80                │
│  └──────┬──────┘                    │
│         │                            │
│         ▼                            │
│  ┌─────────────┐                    │
│  │     PHP     │                    │
│  │    DVWA     │                    │
│  └──────┬──────┘                    │
│         │                            │
│         ▼                            │
│  ┌─────────────┐                    │
│  │    MySQL    │                    │
│  │  initialized│                    │
│  │   database  │                    │
│  └─────────────┘                    │
│                                     │
└─────────────────────────────────────┘
```

No external database container is required.

---

## Repository

Source code:

https://github.com/aracloud/dvwa-alpine

The repository contains:

```text
dvwa-alpine/
├── .github/
│   └── workflows/
├── Dockerfile
├── LICENSE
├── README.md
├── config.inc.php
├── entrypoint.sh
├── init.sql
├── login.php
└── nginx.conf
```

---

## Intended Use

This container is intended for:

- Security demonstrations
- Application security testing
- WAF demonstrations
- F5 Distributed Cloud demonstrations
- Reverse-proxy testing
- Load-balancer testing
- Penetration-testing labs
- Security training
- Docker demonstrations
- Isolated lab environments

The image intentionally prioritizes **simple deployment and fast startup** over production architecture.

---

## Security Warning

**DVWA is intentionally vulnerable.**

Do not deploy this container as a production application.

Do not expose the container directly to an untrusted network unless appropriate network controls and access restrictions are in place.

Recommended:

- Isolate the container in a dedicated lab network
- Restrict access with firewall rules
- Use a WAF or reverse proxy where appropriate
- Do not use the default credentials outside a controlled lab
- Do not store sensitive information in the application

---

## Disclaimer

This project is provided for educational, testing and demonstration purposes.

The author assumes no responsibility for damage, data loss, unauthorized access or other consequences resulting from the use or misuse of this software.

**Use at your own risk and only in environments where you have authorization to perform security testing.**

---

## License

This project is licensed under the **GNU General Public License v3.0**.

See [`LICENSE`](LICENSE) for details.

DVWA is an open-source project maintained by the DVWA community:

https://github.com/digininja/DVWA

---

## Author

**aracloud**

GitHub:

https://github.com/aracloud