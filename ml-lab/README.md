# ML Lab (Anaconda + JupyterLab via Docker Compose)

This setup runs **Anaconda environment**, **JupyterLab**, and **common ML libraries** inside a Docker container with optimized dependency caching and automatic environment updates. The local `notebooks/` folder is mounted so your notebooks are persisted.

## 1) Folder Structure

```
ml-lab/
├─ docker-compose.yml
├─ Dockerfile
├─ environment.yml
├─ build.sh             # Optimized build script with caching
├─ .env                 # Jupyter token (optional, but recommended)
├─ .env_hash            # Auto-generated for dependency tracking
└─ notebooks/           # Your notebooks (local volume)
    └─ hello-world.ipynb # Sample notebook
```

> The `.env` file should be in the same directory as `docker-compose.yml`.

## 2) Prerequisites

* Docker & Docker Compose installed
* Create `notebooks/` folder (or use the existing one with sample notebook)
* Set Jupyter token in `.env` file (optional):

```
JUPYTER_TOKEN=mySecureToken
PYTHON_VERSION=3.13
```

> If `.env` is not provided, default token will be `ml1234` and Python version will be `3.13`.

## 3) Quick Start (Recommended)

Use the optimized build script for best performance:

```bash
# Simple build and start
./build.sh

# Build with specific Python version
./build.sh --python-version 3.11

# Force rebuild from scratch
./build.sh --rebuild-all

# Force rebuild even if no changes detected
./build.sh --force

# View help
./build.sh --help
```

## 4) Manual Commands (Alternative)

If you prefer manual control:

```bash
# First build & start
docker compose build
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f ml-lab

# Stop/restart
docker compose down
docker compose up -d
```

## 5) Access Jupyter

Open in browser:
**[http://localhost:8888](http://localhost:8888)**

Login token:

* With `.env`: Your `JUPYTER_TOKEN` value
* Without `.env`: `ml1234`

Notebook working directory: `/workspace` (mapped to local `notebooks/`)

## 6) Key Features

### Smart Dependency Caching
- The build script tracks changes to `environment.yml` using MD5 hashing
- Only rebuilds when dependencies actually change
- Persistent conda environment volume for faster container restarts

### Auto Environment Updates
- Container automatically detects `environment.yml` changes at runtime
- Updates conda environment without full rebuild when possible
- Maintains environment state across container restarts

### Configurable Python Version
- Set Python version via environment variable or build argument
- Default: Python 3.13
- Supports any Python version available in conda

## 7) Adding New Libraries

### (A) Temporary (for quick testing)

Install inside container — will be lost when container is removed.

```bash
docker exec -it ml-lab bash

# conda or pip — environment: mlenv
conda install -n mlenv -y <package_name>
# or
conda run -n mlenv pip install <package_name>
```

### (B) Permanent (persists after rebuild)

Add package to `environment.yml`:

```yaml
name: mlenv
channels:
  - conda-forge
  - defaults
dependencies:
  - jupyter
  - ipykernel
  - numpy
  - <new-package>
```

Then rebuild:
```bash
./build.sh
```

The smart caching will detect the change and update only the necessary components.

## 8) Build Script Options

The `build.sh` script provides several optimization features:

- `--rebuild-all`: Complete rebuild without cache (useful for major updates)
- `--force`: Force rebuild even if no changes detected
- `--python-version VERSION`: Set specific Python version
- Automatic change detection for `environment.yml`
- Progress indicators and helpful output
- Post-build status summary

## 9) Troubleshooting

### Container won't start
```bash
docker compose logs -f ml-lab
```

### Clear everything and rebuild
```bash
docker compose down -v
./build.sh --rebuild-all
```

### Access container shell
```bash
docker compose exec ml-lab bash
```

### Check conda environment
```bash
docker compose exec ml-lab conda list -n mlenv
```
