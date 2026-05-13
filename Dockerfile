# Build a development image for nbdev based on the Jupyter Docker Stacks.
#
# The base image is configurable via the BASE_IMAGE build arg so any image
# from https://github.com/jupyter/docker-stacks/tree/main/images can be used,
# e.g.:
#   docker build --build-arg BASE_IMAGE=quay.io/jupyter/minimal-notebook:latest -t nbdev-dev .
#   docker build --build-arg BASE_IMAGE=quay.io/jupyter/scipy-notebook:latest   -t nbdev-dev .
#   docker build --build-arg BASE_IMAGE=quay.io/jupyter/datascience-notebook:latest -t nbdev-dev .
ARG BASE_IMAGE=quay.io/jupyter/minimal-notebook:latest
FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.source="https://github.com/AnswerDotAI/nbdev"
LABEL org.opencontainers.image.description="nbdev development environment built on the Jupyter Docker Stacks with Quarto preinstalled"

# Quarto version: set to "latest" or pin to a specific release (e.g. 1.5.57).
ARG QUARTO_VERSION=latest

# Install Quarto (requires root). The Jupyter Docker Stacks default user is
# ${NB_USER} (jovyan); we switch to root for system installs and back at the end.
USER root

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends curl ca-certificates gdebi-core; \
    arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
        amd64) qarch=amd64 ;; \
        arm64) qarch=arm64 ;; \
        *) echo "Unsupported architecture: $arch" >&2; exit 1 ;; \
    esac; \
    if [ "$QUARTO_VERSION" = "latest" ]; then \
        url="https://quarto.org/download/latest/quarto-linux-${qarch}.deb"; \
    else \
        url="https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${qarch}.deb"; \
    fi; \
    curl -fLo /tmp/quarto.deb "$url"; \
    gdebi --non-interactive /tmp/quarto.deb; \
    rm -f /tmp/quarto.deb; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    quarto --version

# Install nbdev and its dev dependencies into the base image's Python env.
# We copy the project metadata only (not the full source) so that this layer
# can be cached across source changes; the working directory is expected to
# be mounted by the devcontainer / user.
USER ${NB_UID}

RUN pip install --no-cache-dir "nbdev[dev]" pre-commit

# Ensure Quarto uses the conda Python (which has Jupyter, PyYAML, etc.)
# rather than the OS /usr/bin/python3, which lacks these packages.
ENV QUARTO_PYTHON=/opt/conda/bin/python

WORKDIR "${HOME}"
