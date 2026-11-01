<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.31

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.31** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The Docker action's runs.image points to an image by a mutable tag instead of a sha256 digest: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.29"`. Whoever controls that tag can change what runs. Pin it as ghcr.io/lukaszraczylo/semver-generator@sha256:<digest> # 1.18.29.

Locations:

- `action.yml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/lukaszraczylo/semver-generator:1.18.29@sha256:ff2efec8932e9025cb3d7ad5c4c5c737d16040317e7374d4fd7bd379d035f3ce.

