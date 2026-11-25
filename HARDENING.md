<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.57

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.57** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The Docker action's runs.image points to a mutable tag, not a SHA digest: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.55"`. Whoever controls that tag can change what it points to, so the action could start running a different image without any change here. Pin it to a digest instead, e.g. `docker://ghcr.io/lukaszraczylo/semver-generator@sha256:<digest> # 1.18.55`.

Locations:

- `action.yml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/lukaszraczylo/semver-generator:1.18.55@sha256:7ed68fe5b5a8861a86af7d09e0a93596d3082c7d3ec3a2f869932fbbe2bb60db. The docker:// scheme and the tag are kept in place. The digest came from a registry lookup.

