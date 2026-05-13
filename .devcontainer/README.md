# nbdev devcontainers

This folder defines several Dev Container configurations, one per Jupyter
Docker Stacks base image. When you open the repo in VS Code (desktop or
[vscode.dev](https://vscode.dev/)) or in GitHub Codespaces and run
**Dev Containers: Reopen in Container** (or **Codespaces: Create Codespace**),
you'll be prompted to pick one:

| Variant | Base image | Use it when… |
| --- | --- | --- |
| `nbdev (minimal)` | `quay.io/jupyter/minimal-notebook` | You only need Python + Jupyter + Quarto + nbdev. Smallest / fastest. |
| `nbdev (scipy)` | `quay.io/jupyter/scipy-notebook` | You want the scientific Python stack (numpy, pandas, matplotlib, scikit-learn, …). |
| `nbdev (datascience)` | `quay.io/jupyter/datascience-notebook` | You also want R (tidyverse) and Julia kernels. |
| `nbdev (pytorch)` | `quay.io/jupyter/pytorch-notebook` | You want PyTorch preinstalled. |
| `nbdev (tensorflow)` | `quay.io/jupyter/tensorflow-notebook` | You want TensorFlow preinstalled. |

All variants share the same [Dockerfile](../Dockerfile) at the repo root —
they only differ in the `BASE_IMAGE` build arg.

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
