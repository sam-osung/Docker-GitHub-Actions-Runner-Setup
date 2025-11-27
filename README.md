# Self-Hosted GitHub Actions Runner (Dockerized)

This repository provides an easy way to deploy a **self-hosted GitHub Actions runner** on any Linux server using **Docker** and **Docker Compose**. The runner automatically registers itself with your GitHub repository and starts processing workflow jobs immediately.

---

## Project Structure

Here’s what each file in this repo does:

### Dockerfile

Defines the Docker image for the GitHub Actions runner. It installs all required tools (curl, git, jq, Docker CLI support, etc.) and downloads the GitHub runner binaries.

### docker-compose.yml

Orchestrates the runner container. It:

* Builds the Dockerfile
* Loads environment variables from `.env`
* Mounts Docker socket so jobs can run Docker inside the container
* Persists `_work` directory for caching and builds

### .env

Holds environment variables required for runner registration. You **must edit this file** before running the setup.

### entrypoint.sh

This script runs when the container starts. It:

* Fixes permissions for the runner directory
* Requests a registration token from GitHub
* Runs `config.sh` to register the runner
* Starts the runner with `run.sh`

---

## Setup Guide

Follow these instructions step-by-step.

### 1️⃣ Install Docker (Ubuntu / Debian)

```bash
sudo apt update
sudo apt install -y docker.io
sudo usermod -aG docker $USER  # Add current user to the docker group
```

Verify installation:

```bash
docker --version
```

### 2️⃣ Install Docker Compose

If your server doesn't already have it:

```bash
sudo apt install docker-compose
```

Verify installation:

```bash
docker-compose --version
```

### 3️⃣ Clone This Repository

```bash
git clone https://github.com/sam-osung/Docker-GitHub-Actions-Runner-Setup.git
cd Docker-GitHub-Actions-Runner-Setup
```

### 4️⃣ Configure .env File

Edit the `.env` file:

```
GITHUB_PAT=your_github_token_here
REPO=your-username/your-repo
RUNNER_NAME=my-docker-runner
```

#### ✔️ Required token permissions

Your GitHub Personal Access Token must have:

* `repo` (full)
* `admin:repo_hook`
* **Administration → Read & Write**
* `workflow`

Generate a token here: [GitHub Tokens](https://github.com/settings/tokens?type=beta)

### 5️⃣ Start the GitHub Runner

```bash
docker-compose up -d
```

Check logs:

```bash
docker logs -f github-runner
```

If the runner starts successfully, you’ll see:

```
Runner successfully added
Connected to GitHub
Listening for jobs...
```

### 6️⃣ Verify in GitHub UI

Go to:

```
Settings → Actions → Self-Hosted Runners
```

You should see your runner registered with the name:

```
docker-runner
```

### Stopping the Runner

Stop container:

```bash
docker-compose down
```

