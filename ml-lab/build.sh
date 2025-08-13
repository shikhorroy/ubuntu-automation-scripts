#!/bin/bash

# ML Lab Docker Build Script
# This script provides optimized building with dependency caching

set -e

echo "🔧 ML Lab Docker Build & Deploy Script"
echo "======================================"

# Default values
REBUILD_ALL=false
FORCE_REBUILD=false
PYTHON_VERSION=${PYTHON_VERSION:-3.13}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --rebuild-all)
            REBUILD_ALL=true
            shift
            ;;
        --force)
            FORCE_REBUILD=true
            shift
            ;;
        --python-version)
            PYTHON_VERSION="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --rebuild-all     Rebuild from scratch (no cache)"
            echo "  --force          Force rebuild even if no changes detected"
            echo "  --python-version VERSION  Set Python version (default: 3.13)"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check if environment.yml has changed
ENV_CHANGED=false
if [ -f "environment.yml" ]; then
    ENV_HASH=$(md5sum environment.yml | cut -d' ' -f1)
    LAST_ENV_HASH=""

    if [ -f ".env_hash" ]; then
        LAST_ENV_HASH=$(cat .env_hash)
    fi

    if [ "$ENV_HASH" != "$LAST_ENV_HASH" ]; then
        ENV_CHANGED=true
        echo "📦 Detected changes in environment.yml"
    fi
else
    echo "⚠️  Warning: environment.yml not found"
fi

# Determine build strategy
if [ "$REBUILD_ALL" = true ]; then
    echo "🔄 Rebuilding everything from scratch..."
    docker-compose build --no-cache --build-arg PYTHON_VERSION=${PYTHON_VERSION}
elif [ "$FORCE_REBUILD" = true ] || [ "$ENV_CHANGED" = true ]; then
    echo "🔨 Building with updated dependencies..."
    docker-compose build --build-arg PYTHON_VERSION=${PYTHON_VERSION}
else
    echo "✅ No changes detected. Using cached build..."
    docker-compose build --build-arg PYTHON_VERSION=${PYTHON_VERSION}
fi

# Save current environment hash
if [ -f "environment.yml" ]; then
    md5sum environment.yml | cut -d' ' -f1 > .env_hash
fi

echo ""
echo "🚀 Starting ML Lab container..."
docker-compose up -d

echo ""
echo "✅ ML Lab is ready!"
echo "📊 Jupyter Lab: http://localhost:8888"
echo "🔑 Token: ${JUPYTER_TOKEN:-ml1234}"
echo ""
echo "📋 Useful commands:"
echo "  docker-compose logs -f ml-lab    # View logs"
echo "  docker-compose exec ml-lab bash  # Access container shell"
echo "  docker-compose down              # Stop container"
