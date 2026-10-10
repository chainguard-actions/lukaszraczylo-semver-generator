<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.21

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.21** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The action.yml Docker action references a mutable image tag (`docker://ghcr.io/lukaszraczylo/semver-generator:1.18.19`) instead of an immutable SHA digest. This means the image could be replaced with a different (potentially malicious) version without changing the action.yml reference, creating a supply-chain attack risk. It should be pinned to a SHA digest, e.g. `docker://ghcr.io/lukaszraczylo/semver-generator@sha256:<64-hex-char-digest> # 1.18.19`.

Locations:

- `action.yml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned the Docker image reference in action.yml from `docker://ghcr.io/lukaszraczylo/semver-generator:1.18.19` to `docker://ghcr.io/lukaszraczylo/semver-generator:1.18.19@sha256:ab4eed3e409f40b16373cd00036023368eb57d8ff5f839139d39453feb3af7ab`, preserving the `docker://` scheme and the tag inline as required.

