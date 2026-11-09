<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.37

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.37** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The Docker action's runs.image points to an image by a mutable tag rather than a SHA digest: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.35"`. Whoever controls that tag could change the image behind it, so pin it as `ghcr.io/lukaszraczylo/semver-generator@sha256:<digest> # 1.18.35`.

Locations:

- `action.yml:40`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/lukaszraczylo/semver-generator:1.18.35@sha256:b9896695dbc1f91a6edcbf229ebbec3cf901859d3b7161034a52f4519432d4a0.

