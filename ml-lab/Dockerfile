FROM continuumio/anaconda3:2024.10-1

# Accept Python version as build argument
ARG PYTHON_VERSION=3.13

WORKDIR /opt/app

RUN conda update -n base -c defaults conda -y

# Create conda environment
RUN conda create -n mlenv python=${PYTHON_VERSION} -y && conda clean -afy

RUN conda install -n base conda-env -y

ENV PATH="/opt/conda/envs/mlenv/bin:${PATH}"

# Copy environment.yml first for better layer caching
COPY environment.yml /tmp/environment.yml

# Install dependencies during build time
RUN conda env update -n mlenv -f /tmp/environment.yml --prune && \
    conda clean -afy && \
    touch /opt/conda/envs/mlenv/.last_update

RUN mkdir -p /workspace
WORKDIR /workspace

EXPOSE 8888
