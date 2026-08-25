#!/bin/bash
set -e

# kubectl and the Flyte SDK are pre-installed in the devcontainer image
# (.devcontainer/Dockerfile), so the only remaining setup here is generating
# .flyte/config.yaml for the workspace.

mkdir -p .flyte
touch .flyte/config.yaml
echo "Generating .flyte/config.yaml"
flyte create config --endpoint localhost:30080 --insecure --overwrite
