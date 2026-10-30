<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.29

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.29** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The Docker action's runs.image uses a tag that can change, not a SHA digest: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.27"`. Pin it to `ghcr.io/lukaszraczylo/semver-generator@sha256:<digest> # 1.18.27`.

Locations:

- `action.yml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/lukaszraczylo/semver-generator:1.18.27@sha256:51c11765e3e82b1a78c5e3fb772f12d95129d5ba57bd0a52af092a1a6ae3caa2

