#!/bin/bash
set -e

# The devbox image is pinned by digest. The upstream tag `:latest` moves
# frequently, and `docker pull` with a floating tag silently re-downloads
# layers whenever it moves, slowing down codespace restarts. A pinned digest
# makes the pull a no-op when the image is already in the local Docker store.
#
# To pick up a newer devbox release, fetch the current `:latest` digest with:
#   docker buildx imagetools inspect cr.flyte.org/flyteorg/flyte-devbox:latest
# and update the digest below.
FLYTE_DEVBOX_IMAGE="cr.flyte.org/flyteorg/flyte-devbox@sha256:c119ad4d62831e96c530002620efbee3a350bc8613f03c06b336faf3d01c8f3b"

# Start Flyte devbox if it is not already running (paused clusters are resumed
# by `flyte start devbox`, so only skip when the container is actively running).
if ! docker ps --filter "name=^flyte-devbox$" --filter "status=running" --format '{{.Names}}' | grep -q "flyte-devbox"; then
    echo "Starting Flyte devbox cluster..."
    echo "Note: First launch pulls container images and may take a few minutes."
    flyte start devbox --image "$FLYTE_DEVBOX_IMAGE"
else
    echo "Flyte devbox cluster is already running."
fi
