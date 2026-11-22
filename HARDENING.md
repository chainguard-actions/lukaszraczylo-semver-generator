<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.53

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.53** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The Docker action's runs.image points to a mutable tag, not a SHA digest: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.51"`. Pin it to an immutable digest instead, e.g. ghcr.io/lukaszraczylo/semver-generator@sha256:<digest> # 1.18.51.

Locations:

- `action.yml:39`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to its digest: docker://ghcr.io/lukaszraczylo/semver-generator:1.18.51@sha256:8e657238552f2f15df1989c3713b904a9df0f91893f65f11fb1011e091d86fa3. The docker:// scheme and the 1.18.51 tag are unchanged.

