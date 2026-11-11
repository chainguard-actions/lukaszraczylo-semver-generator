<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.41

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.41** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The Docker action's runs.image points to a mutable tag, not a SHA digest: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.39"`. Pin it to a digest, e.g. `docker://ghcr.io/lukaszraczylo/semver-generator@sha256:<digest> # 1.18.39`.

Locations:

- `action.yml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/lukaszraczylo/semver-generator:1.18.39@sha256:95117129bcd51b5a41af2fe81e65d25bf02a6d5bfd97c9fb20e4782431658313

