# Devcontainer image with client-side dependencies baked in.
#
# Installing kubectl and the Flyte SDK here (at image build time) instead of
# in post-create.sh saves ~1-2 minutes on every codespace creation and makes
# the environment deterministic.
#
# The docker-in-docker feature is still declared in devcontainer.json because
# it wires up dockerd startup at container boot; it cannot be baked in here.
FROM mcr.microsoft.com/devcontainers/python:3.12-bookworm

# kubectl (replaces the kubectl-helm-minikube feature; helm/minikube are not
# needed by this workspace). Architecture-aware so the build works on both
# amd64 and arm64 codespace hosts.
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && \
    case "$(uname -m)" in \
        x86_64)  KUBECTL_ARCH=amd64 ;; \
        aarch64) KUBECTL_ARCH=arm64 ;; \
        *) echo "unsupported architecture: $(uname -m)" && exit 1 ;; \
    esac && \
    KUBECTL_VERSION="$(curl -fsSL https://dl.k8s.io/release/stable.txt)" && \
    curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl" \
        -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    rm -rf /var/lib/apt/lists/*

# Flyte SDK (replaces `pip install --upgrade flyte` in post-create.sh).
# Bump this pin to pick up newer SDK releases.
RUN pip install --no-cache-dir flyte==2.6.7
