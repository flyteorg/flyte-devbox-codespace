#!/usr/bin/env bash
# Runs on every codespace start: bring up the Flyte devbox cluster if it isn't
# already running. Safe to re-run.
set -euo pipefail

FLYTE_URL="http://localhost:30080"

devbox_up() {
    curl -s -o /dev/null --max-time 2 "$FLYTE_URL"
}

if devbox_up; then
    echo "==> Flyte devbox is already running at $FLYTE_URL"
    exit 0
fi

echo "==> Starting the Flyte devbox (first boot pulls images — this can take a few minutes)"
flyte start devbox

echo "==> Waiting for the devbox to become reachable at $FLYTE_URL"
for _ in $(seq 1 120); do
    if devbox_up; then
        echo ""
        echo "==> Flyte devbox is up! 🚀"
        echo "    UI:  open the forwarded port 30080 (PORTS tab in VS Code)"
        echo "    Try: flyte run examples/hello.py main"
        exit 0
    fi
    sleep 5
done

echo "==> Timed out waiting for the devbox. Check status with:" >&2
echo "    docker ps && kubectl get pods -A" >&2
exit 1
