"""A tiny extract → transform → summarize pipeline.

Shows how typed outputs flow between tasks — Flyte serializes and versions the
data between each step, and you can inspect every intermediate value in the UI.

    flyte run examples/pipeline.py main
"""

import random
import statistics

import flyte

env = flyte.TaskEnvironment(
    name="pipeline",
    resources=flyte.Resources(cpu="500m", memory="512Mi"),
)


@env.task
def extract(n: int) -> list[float]:
    """Pretend to pull raw measurements from an upstream source."""
    rng = random.Random(42)
    return [rng.gauss(mu=100.0, sigma=15.0) for _ in range(n)]


@env.task
def transform(data: list[float]) -> list[float]:
    """Drop outliers beyond two standard deviations."""
    mean = statistics.mean(data)
    stdev = statistics.stdev(data)
    return [x for x in data if abs(x - mean) <= 2 * stdev]


@env.task
def summarize(data: list[float]) -> dict[str, float]:
    return {
        "count": float(len(data)),
        "mean": statistics.mean(data),
        "stdev": statistics.stdev(data),
        "min": min(data),
        "max": max(data),
    }


@env.task
def main(n: int = 100) -> dict[str, float]:
    raw = extract(n)
    cleaned = transform(raw)
    summary = summarize(cleaned)
    print(f"Kept {len(cleaned)}/{n} rows: {summary}")
    return summary


if __name__ == "__main__":
    flyte.init_from_config()
    run = flyte.run(main, n=100)
    print(f"Run submitted: {run.url}")
