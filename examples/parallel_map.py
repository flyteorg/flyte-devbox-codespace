"""Fan out work across many parallel task instances with `flyte.map`.

Each mapped task runs in its own container on the devbox cluster, so keep an
eye on the UI to watch them run side by side.

    flyte run examples/parallel_map.py main
"""

import flyte

env = flyte.TaskEnvironment(
    name="parallel_map",
    resources=flyte.Resources(cpu="250m", memory="256Mi"),
)


@env.task
def square(x: int) -> int:
    return x * x


@env.task
def main(n: int = 10) -> float:
    # flyte.map works like Python's map, but each call runs as a parallel task.
    squares = list(flyte.map(square, range(n)))
    mean = sum(squares) / len(squares)
    print(f"Mean of the first {n} squares: {mean}")
    return mean


if __name__ == "__main__":
    flyte.init_from_config()
    run = flyte.run(main, n=10)
    print(f"Run submitted: {run.url}")
