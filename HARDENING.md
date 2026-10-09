<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.19

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.19** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The action.yml uses a Docker image referenced by a mutable tag (`docker://ghcr.io/lukaszraczylo/semver-generator:1.18.17`) instead of an immutable SHA digest. This means the image could be silently replaced with a different (potentially malicious) version without any change to the action definition. It should be pinned to a specific SHA digest, e.g. `docker://ghcr.io/lukaszraczylo/semver-generator@sha256:<64-hex-char-digest>`.

Locations:

- `action.yml:43`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned the Docker image reference in action.yml from `docker://ghcr.io/lukaszraczylo/semver-generator:1.18.17` to `docker://ghcr.io/lukaszraczylo/semver-generator:1.18.17@sha256:61b241f5cf1922c7495e8401206c781ac32f8471c67088d4bad79265663ce4db`, preserving the docker:// scheme and the tag inline as required.

