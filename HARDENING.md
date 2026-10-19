<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.27

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.27** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The action.yml uses a Docker image reference with a mutable version tag instead of an immutable SHA256 digest. `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.18.25"` — the tag `1.18.25` can be overwritten at any time, allowing a supply-chain attacker to silently replace the image content without changing the reference. It should be pinned to a full SHA256 digest, e.g. `image: "docker://ghcr.io/lukaszraczylo/semver-generator@sha256:<64-hex-char-digest> # 1.18.25"`.

Locations:

- `action.yml:37`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned the Docker image reference in action.yml from `docker://ghcr.io/lukaszraczylo/semver-generator:1.18.25` to `docker://ghcr.io/lukaszraczylo/semver-generator:1.18.25@sha256:69b913ef6994cf1504f3a55acb70c996545d5dcefb815ded6a56fe1edc2cf164`, preserving the docker:// scheme and the tag inline alongside the immutable digest.

