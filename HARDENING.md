<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.17.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.17.6** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple workflow files and action.yml use mutable tag/branch refs instead of pinned full-length SHA commit hashes, making them vulnerable to supply-chain attacks.

Failing references:
- autoupdate.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-autoupdate.yaml@main`
- pr.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-pr.yaml@main`
- release.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-release.yaml@main`, `uses: actions/checkout@v4`
- static.yml: `uses: actions/checkout@v4`, `uses: actions/configure-pages@v5`, `uses: actions/upload-pages-artifact@v3`, `uses: actions/deploy-pages@v4`
- action.yml: `image: docker://ghcr.io/lukaszraczylo/semver-generator:1.17.4` uses a mutable version tag instead of a SHA digest (e.g. `@sha256:<digest>`).

Locations:

- `.github/workflows/autoupdate.yaml:14`
- `.github/workflows/pr.yaml:13`
- `.github/workflows/release.yaml:13`
- `.github/workflows/release.yaml:24`
- `.github/workflows/static.yml:28`
- `.github/workflows/static.yml:30`
- `.github/workflows/static.yml:32`
- `.github/workflows/static.yml:36`
- `action.yml:35`

### script-injection (severity: high)

Sub-rule (a) violation: In the 'Commit and push' step of release.yaml, the expression `${{ needs.release.outputs.version }}` is directly interpolated inside a `run:` shell command string (the git commit message). This value flows through YAML template substitution before the shell sees it, allowing an attacker who can influence the release output to inject arbitrary shell metacharacters.

Offending line:
  `git commit -m "chore: pin action.yml Docker image to v${{ needs.release.outputs.version }}"`

Fix: Move the value into an `env:` variable and reference it as a quoted shell variable: `"$VERSION"`.

Locations:

- `.github/workflows/release.yaml:44`

### missing-permissions (severity: medium)

The workflow file pr.yaml has no top-level `permissions:` key, and its single job (`pr-checks`) also has no job-level `permissions:` key. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad (write access to contents by default on many repositories).

Locations:

- `.github/workflows/pr.yaml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection, missing-permissions

**Notes:**

Fixed all three findings:

1. **unpinned-uses**: Pinned all mutable action references to full SHA commit hashes:
   - `lukaszraczylo/shared-actions/...@main` → `@72ef4441eb6e36c1e8c5d26d91cd1a3470c63d61 # main` (autoupdate.yaml, pr.yaml, release.yaml)
   - `actions/checkout@v4` → `@11d5960a326750d5838078e36cf38b85af677262 # v4` (release.yaml, static.yml)
   - `actions/configure-pages@v5` → `@983d7736d9b0ae728b81ab479565c72886d7745b # v5` (static.yml)
   - `actions/upload-pages-artifact@v3` → `@56afc609e74202658d3ffba0e8f6dda462b719fa # v3` (static.yml)
   - `actions/deploy-pages@v4` → `@d6db90164ac5ed86f2b6aed7e0febac5b3c0c03e # v4` (static.yml)
   - Docker image in action.yml pinned with SHA digest: `docker://ghcr.io/lukaszraczylo/semver-generator:1.17.4@sha256:427767d4df71515f3e3a2686f5d8c65330d9338b74fe52cf3e3f51086f61d6fc`

2. **script-injection**: In release.yaml's 'Commit and push' step, moved `${{ needs.release.outputs.version }}` into an `env:` block as `VERSION` and referenced it as `${VERSION}` in the shell script.

3. **missing-permissions**: Added `permissions: {}` to pr.yaml at the top level to prevent inheriting overly broad default token permissions.

