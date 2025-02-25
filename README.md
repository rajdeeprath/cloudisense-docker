# Cloudisense on Docker

## Overview
This repository provides a **Dockerized setup** for **Cloudisense**, allowing for **easy deployment and execution**. It includes:
- A **Dockerfile** to build the Cloudisense image.
- A **Docker Compose file** (`docker-compose.yml`) to manage the containerized application.
- Configuration using **environment variables**.

---

## Dockerfile
The `Dockerfile` is used to **build the Cloudisense Docker image**, installing necessary dependencies, setting up logging, and running the application.

### Steps in the Dockerfile
1. Uses **Python 3.8-slim** as the base image.
2. Installs necessary tools (`git`, `unzip`, `wget`).
3. **Clones the Cloudisense Installer** and runs the installation scripts.
4. **Installs Apache Tomcat 7.0.32** and extracts its content to `/root/filesystem`.
5. **Sets up a fake log generator** that continuously writes logs with random log levels (`INFO`, `WARN`, `DEBUG`, `ERROR`).
6. **Defines default environment variables** for configuration.
7. **Exposes port `8000`** for external access.
8. **Starts the log generator and the Cloudisense application**.

### 🔹 Building the Docker Image
To build the Docker image, run:
```bash
sudo docker build -t rajdeeprath/cloudisense:0.0.1 .
```

---

## Docker Compose File (`docker-compose.yml`)
The `docker-compose.yml` file is used to **run the Cloudisense container** with predefined configurations.

### Features
- Runs **Cloudisense as a service**.
- Exposes **port `8000`**.
- **Overrides environment variables** if needed.
- Uses **volumes** to persist logs.

### 🔹 Running the Container
To start the container using Docker Compose, run:
```bash
sudo docker-compose up -d
```
To stop the container:
```bash
sudo docker-compose down
```
To rebuild and restart:
```bash
sudo docker-compose up --build -d
```

---

## ⚙️ Environment Variables
| **Variable** | **Description** | **Default Value** |
|-------------|----------------|------------------|
| `ENV_BIND_HOST` | The host IP address the application binds to | `0.0.0.0` |
| `ENV_LOG_TARGETS` | List of log files monitored by Cloudisense | `[{"enabled": true, "name": "fakelog.log", "log_file_path": "/root/filesystem/logs/fakelog.log"}]` |
| `ENV_ACCESSIBLE_PATHS` | List of directories accessible via the file manager | `["/root/filesystem"]` |
| `ENV_DOWNLOADABLE_PATHS` | List of directories from which files can be downloaded | `["/root/filesystem"]` |
| `ENV_ALLOWED_READ_EXTENSIONS` | Allowed file extensions for reading | `[".properties", ".xml", ".txt", ".ini", ".log", ".sh", ".bat"]` |
| `ENV_ALLOWED_WRITE_EXTENSIONS` | Allowed file extensions for writing | `[".properties", ".xml", ".txt", ".ini", ".log"]` |

---

## Debugging & Logs
To **view logs** from the running container:
```bash
sudo docker-compose logs -f
```
To **manually enter the container**:
```bash
sudo docker exec -it cloudisense bash
```
To check if **log generation is working**:
```bash
cat /root/filesystem/logs/fakelog.log
```

---

## Summary
- The **Dockerfile** builds an image containing **Cloudisense** and its dependencies.
- The **Docker Compose file** manages the container runtime with **environment variables and volumes**.
- **Fake logs are generated continuously**, and **all configurations can be overridden via environment variables**.