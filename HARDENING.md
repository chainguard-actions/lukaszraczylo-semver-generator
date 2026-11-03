<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.33

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.33** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

action.yml runs.image references a mutable tag instead of a SHA digest: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.31"`. Pin it to an @sha256:<digest> reference.

Locations:

- `action.yml:39`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/lukaszraczylo/semver-generator:1.18.31@sha256:d82bb6a93d5c338f75fcb86a011c2a771e7c542fddcc8ad7f3959c41d3a3c4e0, keeping the docker:// scheme and the tag inline.

