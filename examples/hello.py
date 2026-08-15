"""The smallest possible Flyte workflow: one task calling another.

Run it on the devbox with:

    flyte run examples/hello.py main

or directly as a script:

    python examples/hello.py
"""

import flyte

# A TaskEnvironment groups tasks that share the same image and resources.
# The devbox runs on a small Codespaces machine, so we keep requests tiny.
env = flyte.TaskEnvironment(
    name="hello",
    resources=flyte.Resources(cpu="250m", memory="256Mi"),
)


@env.task
def greet(name: str) -> str:
    return f"Hello, {name}! 👋 Greetings from the Flyte devbox."


@env.task
def main(name: str = "world") -> str:
    greeting = greet(name)
    print(greeting)
    return greeting


if __name__ == "__main__":
    flyte.init_from_config()
    run = flyte.run(main, name="world")
    print(f"Run submitted: {run.url}")
