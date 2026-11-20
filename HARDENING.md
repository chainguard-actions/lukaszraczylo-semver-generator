<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.51

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.51** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

This Docker action's runs.image points to a mutable tag instead of a SHA digest: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.49"`. Whoever controls the registry tag can change the image the action runs. Pin it to a digest, e.g. `docker://ghcr.io/lukaszraczylo/semver-generator@sha256:<digest> # 1.18.49`.

Locations:

- `action.yml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/lukaszraczylo/semver-generator:1.18.49@sha256:bfc7356f7baa7cdb2f0914694f15fbf6357819a0a1947c8cee0b847f8ca8d2e9, keeping the docker:// scheme and the tag inline.

