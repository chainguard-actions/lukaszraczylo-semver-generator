<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.39

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.39** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The Docker action's runs.image uses a mutable tag instead of a SHA digest: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.37"`. Pin it to an @sha256:<digest> reference.

Locations:

- `action.yml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/lukaszraczylo/semver-generator:1.18.37@sha256:d0187c395c4a592a90e46866aa1b21528b8fbd86800e69ec64ea921f1852837a

