<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.45

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.45** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The Docker action's runs.image points to a mutable tag, not a sha256 digest: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.43"`. Pin it to an immutable digest, e.g. ghcr.io/lukaszraczylo/semver-generator@sha256:<digest> # 1.18.43.

Locations:

- `action.yml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/lukaszraczylo/semver-generator:1.18.43@sha256:980741ab86ef9cd5bb8bf4d76bce28ecfa8cf617098df33be95be99e93489832 (digest resolved via registry).

