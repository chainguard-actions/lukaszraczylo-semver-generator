<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.59

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.59** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The Docker action's runs.image points to a mutable tag instead of a SHA digest: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.57"`. Whoever controls the registry can move that tag to a different image. Pin it to a digest instead, e.g. ghcr.io/lukaszraczylo/semver-generator@sha256:<digest> # 1.18.57.

Locations:

- `action.yml:39`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/lukaszraczylo/semver-generator:1.18.57@sha256:7aeced5983459a9b0694c5e59aef2e348c093f8728d99fb0c0bad40eec27af5a, keeping the docker:// scheme and tag inline.

