# nbdev devcontainers

This folder defines several Dev Container configurations, one per Jupyter
Docker Stacks base image. When you open the repo in VS Code (desktop or
[vscode.dev](https://vscode.dev/)) or in GitHub Codespaces and run
**Dev Containers: Reopen in Container** (or **Codespaces: Create Codespace**),
you'll be prompted to pick one:

| Variant | Base image | Use it when… |
| --- | --- | --- |
| **`nbdev` ★** | `quay.io/jupyter/scipy-notebook` | **You are contributing to nbdev itself.** Adds black, GitLens, GitHub PR + pre-commit and format-on-save. |
| `nbdev (minimal)` | `quay.io/jupyter/minimal-notebook` | You only need Python + Jupyter + Quarto + nbdev. Smallest / fastest. |
| `nbdev (r)` | `quay.io/jupyter/r-notebook` | R + tidyverse + IRkernel. |
| `nbdev (julia)` | `quay.io/jupyter/julia-notebook` | Julia + IJulia. |
| `nbdev (scipy)` | `quay.io/jupyter/scipy-notebook` | The scientific Python stack (numpy, pandas, matplotlib, scikit-learn, …). |
| `nbdev (tensorflow)` | `quay.io/jupyter/tensorflow-notebook` | TensorFlow preinstalled. |
| `nbdev (pytorch)` | `quay.io/jupyter/pytorch-notebook` | PyTorch preinstalled. |
| `nbdev (datascience)` | `quay.io/jupyter/datascience-notebook` | Python + R + Julia in one image. |
| `nbdev (pyspark)` | `quay.io/jupyter/pyspark-notebook` | Apache Spark + PySpark; Spark UI ports 4040-4042 forwarded. |
| `nbdev (all-spark)` | `quay.io/jupyter/all-spark-notebook` | Spark with Python, R, and Scala kernels. |

The `nbdev` variant is the recommended one for working on nbdev itself, and
is the **only** variant that builds from the repo [Dockerfile](../Dockerfile).
The rest pull the prebuilt image straight from GHCR
(`ghcr.io/wiki3-ai/nbdev-devcontainer:<variant>`) — they are exemplars of
the "downstream" usage pattern documented in
[`../examples/downstream-devcontainer.json`](../examples/downstream-devcontainer.json),
and let contributors sanity-check that downstream content repos will work on
each Jupyter Docker Stacks variant without rebuilding locally.

## What each container gives you

- **Jupyter Lab** auto-starts on container boot, served on port 8888.
  Set a real token via the `NOTEBOOK_ARGS` env var in the devcontainer.json
  before sharing the URL.
- **Quarto** is preinstalled (`/opt/quarto/bin/quarto`) and the Quarto VS Code
  extension is preconfigured to use the conda Python.
- **nbdev[dev]** is installed; `pip install -e '.[dev]'` runs in
  `postCreateCommand` so contributors get an editable install for free.
- **Passwordless sudo** is available behind a flag — set `GRANT_SUDO=yes` in
  `containerEnv` to enable.

## Publishing & consuming the image

Pushes to `main` and `v*` tags trigger
[`publish-devcontainer.yaml`](../.github/workflows/publish-devcontainer.yaml),
which builds and pushes each variant to GHCR:

```
ghcr.io/wiki3-ai/nbdev-devcontainer:<variant>           # rolling latest
ghcr.io/wiki3-ai/nbdev-devcontainer:<variant>-<branch>  # per branch
ghcr.io/wiki3-ai/nbdev-devcontainer:<variant>-<sha>     # immutable
ghcr.io/wiki3-ai/nbdev-devcontainer:<variant>-<semver>  # on git tags
```

Downstream content repos consume them with a tiny config — see
[`../examples/downstream-devcontainer.json`](../examples/downstream-devcontainer.json).
