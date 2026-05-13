# Examples

## `downstream-devcontainer.json`

A ready-to-copy `.devcontainer/devcontainer.json` for content-only repos that
want to consume the prebuilt `ghcr.io/wiki3-ai/nbdev-devcontainer` image
instead of building their own. See
[`../.devcontainer/README.md`](../.devcontainer/README.md) for the list of
available image tags.

Copy it like this in your downstream repo:

```
mkdir -p .devcontainer
curl -fLo .devcontainer/devcontainer.json \
  https://raw.githubusercontent.com/wiki3-ai/nbdev/main/examples/downstream-devcontainer.json
```

…or just create the file in the GitHub web UI and paste the contents.
