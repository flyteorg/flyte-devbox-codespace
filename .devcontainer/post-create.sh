#!/usr/bin/env bash
# Runs once when the codespace is created: install the Flyte SDK and point it
# at the local devbox cluster.
set -euo pipefail

echo "==> Installing the flyte SDK"
pip install --upgrade flyte

echo "==> Writing Flyte config pointing at the devbox (localhost:30080)"
if [ ! -f .flyte/config.yaml ]; then
    flyte create config \
        --endpoint localhost:30080 \
        --project flytesnacks \
        --domain development \
        --builder local \
        --registry localhost:30000 \
        --force \
        --insecure
else
    echo "    .flyte/config.yaml already exists, skipping"
fi

echo "==> Done. The devbox cluster itself is started by post-start.sh."
