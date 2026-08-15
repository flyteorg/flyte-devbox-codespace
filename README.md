# Flyte Devbox in a Codespace

Try [Flyte](https://www.union.ai/docs/v2/flyte/) in your browser with zero local
setup. This repo ships a devcontainer that automatically starts a
[Flyte devbox](https://www.union.ai/docs/v2/flyte/user-guide/get-started/run-modes/running-devbox/) —
a complete single-node Flyte cluster running inside the codespace — so you can
get a feel for the platform in a few minutes.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/flyteorg/flyte-devbox-codespace?quickstart=1)

> **Machine type:** pick the **4-core** machine when creating the codespace.
> The devbox runs a Kubernetes cluster in Docker and needs the headroom.

## What happens on startup

1. The devcontainer installs the `flyte` SDK and writes `.flyte/config.yaml`
   pointing at the devbox (`localhost:30080`, local image builder).
2. `flyte start devbox` boots the local cluster. The first boot pulls container
   images and takes a few minutes — watch progress in the
   "Running postStartCommand" terminal.
3. Port **30080** (the Flyte UI and API) is forwarded automatically.

## Run your first workflow

Once the devbox is up:

```bash
flyte run examples/hello.py main
```

The CLI prints a link to the run. Open the **PORTS** tab in VS Code and click
the forwarded address for port `30080` to browse the Flyte UI — you'll see the
run's task graph, inputs/outputs, and logs.

## Examples

All examples request tiny amounts of CPU (`250m`–`500m`) so they fit
comfortably on the 4-core codespace:

| Example | What it shows |
|---|---|
| [`examples/hello.py`](examples/hello.py) | The smallest workflow: one task calling another |
| [`examples/parallel_map.py`](examples/parallel_map.py) | Fanning out parallel tasks with `flyte.map` |
| [`examples/pipeline.py`](examples/pipeline.py) | A typed extract → transform → summarize pipeline |

```bash
flyte run examples/parallel_map.py main --n 20
flyte run examples/pipeline.py main --n 500
```

Add `--local` (e.g. `flyte run --local examples/hello.py main`) to run in your
Python process instead of on the devbox cluster.

## Handy commands

```bash
flyte get runs                 # list past runs
flyte stop devbox              # shut the cluster down
flyte start devbox             # bring it back
flyte delete devbox --volume   # remove it entirely, including data
kubectl get pods -A            # peek under the hood
```

## Next steps

- [Flyte documentation](https://www.union.ai/docs/v2/flyte/)
- [Run modes: local, devbox, remote](https://www.union.ai/docs/v2/flyte/user-guide/get-started/run-modes/)
- [Deploy Flyte to a real cluster](https://www.union.ai/docs/v2/flyte/deployment/)
