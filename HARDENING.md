<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.43

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.43** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The Docker action's image is referenced by a tag that can change, not by a SHA digest: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.41"`. Whoever controls that tag can point it at a different image. Pin it to a digest, e.g. `docker://ghcr.io/lukaszraczylo/semver-generator@sha256:<digest> # 1.18.41`.

Locations:

- `action.yml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/lukaszraczylo/semver-generator:1.18.41@sha256:c332c30d6f9eb0d2833acd945258d336ac18f70202e560a98f48a18a39f3e0c2, keeping the docker:// scheme and the tag inline.

