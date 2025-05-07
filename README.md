# Cloudisense Demo on Docker

![Cloudisense Demo](assets/dashboard.png)

---

## 🧭 Overview

This repository provides a **Dockerized setup** for **Cloudisense**, allowing for easy deployment and execution. It includes:

- A **Dockerfile** to build the Cloudisense image.
- A **Docker Compose file** (`docker-compose.yml`) to manage the containerized application.
- Configuration using **environment variables**.

---

## 🛠️ Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/your-repo.git
   ```

2. **Navigate to the project root:**
   ```bash
   cd your-repo
   ```

3. **Open a terminal in this directory** (if not already inside one).

---

## 🔹 Running the Container

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

## ⚙️ Environment Configuration

The `.env` file contains the environment variables required to run the demo.

For example, to try out `SmartAssist`, you’ll need to provide your OpenAI API key by setting:

```env
ENV_OPENAI_API_KEY=your_openai_api_key_here
```

Other variables in the file are pre-filled with demo values for testing purposes.

| **Variable**                    | **Description**                                                                 | **Default Value**                                                                                          |
|--------------------------------|---------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| `ENV_BIND_HOST`                | The host IP address the application binds to                                   | `0.0.0.0`                                                                                                   |
| `ENV_LOG_TARGETS`              | List of log files monitored by Cloudisense                                     | `[{"enabled": true, "name": "fakelog.log", "log_file_path": "/root/filesystem/logs/fakelog.log"}]`         |
| `ENV_ACCESSIBLE_PATHS`         | List of directories accessible via the file manager                            | `["/root/filesystem"]`                                                                                      |
| `ENV_DOWNLOADABLE_PATHS`       | List of directories from which files can be downloaded                         | `["/root/filesystem"]`                                                                                      |
| `ENV_OPENAI_API_KEY`           | String value representing the OpenAI API token for LLM features                | *(empty string by default)*                                                                                |
| `ENV_ALLOWED_READ_EXTENSIONS`  | Allowed file extensions for reading                                            | `[".properties", ".xml", ".txt", ".ini", ".log", ".sh", ".bat"]`                                            |
| `ENV_ALLOWED_WRITE_EXTENSIONS` | Allowed file extensions for writing                                            | `[".properties", ".xml", ".txt", ".ini", ".log"]`                                                           |

---

## 🌐 Accessing Cloudisense in Browser

![Cloudisense Login](assets/login.png)

To access Cloudisense client in the browser, visit:

```
http://localhost:8000
```

### Login Demo Info

- **Host:** `localhost`
- **Port:** `8000`
- **Username:** `administrator`
- **Password:** `changeme`

---

## 🧠 SmartAssist: AI-powered Assistant

SmartAssist is an integrated AI assistant in Cloudisense.

- It can understand questions about system logs, modules, stats, and workflows.
- It uses the OpenAI API to provide intelligent summaries and suggestions.
- The assistant can be invoked from within the Cloudisense dashboard.
- Requires setting `ENV_OPENAI_API_KEY` in the environment to enable.

![SmartAssist](assets/smartassist.png)

---

## 🐳 Docker Compose File

The `docker-compose.yml` file runs Cloudisense in a container with demo configurations and exposes port `8000`.

### Features

- Runs **Cloudisense Demo** as a service.
- Simulates dummy log generation.
- Demonstrates **log viewer**, **file browser**, **stats viewer**, **reaction engine**, and **Smart Assistant**.

---

## 🧱 Dockerfile

The `Dockerfile` builds the Cloudisense Demo Docker image, including:

1. Base image: `python:3.9-slim`
2. Installs `git`
3. Clones Cloudisense Installer and installs it
4. Sets up demo profile (`cloudisensedemo`)
5. Downloads and extracts Apache Tomcat for browsing
6. Sets up a fake log generator
7. Defines default environment variables
8. Exposes port `8000`
9. Starts log generator and application

### 🔨 Building the Docker Image

```bash
sudo docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t rajdeeprath/cloudisense:0.0.2 \
  -t rajdeeprath/cloudisense:latest \
  -f Dockerfile \
  --push .
```

---

## 🐋 DockerHub

You can find the images here:  
[CloudiSENSE on Docker Hub](https://hub.docker.com/repository/docker/rajdeeprath/cloudisense/general)

---

## 🪵 Debugging & Logs

To view logs from the container:

```bash
sudo docker-compose logs -f
sudo docker-compose logs -f cloudisense
```

To check log generation:

```bash
cat /root/filesystem/logs/fakelog.log
```

---

## ✅ Summary

- **Dockerfile** builds a complete image of Cloudisense with dependencies.
- **Docker Compose** runs the app using demo configuration.
- **SmartAssist** and **other modules** demonstrate CloudiSENSE features.
- **Environment variables** can be customized as needed.
