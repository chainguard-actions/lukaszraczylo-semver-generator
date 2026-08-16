<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.17.14

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.17.14** was hardened automatically. 3 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple workflow files and action.yml reference mutable tags/branches instead of pinned SHA digests, making them vulnerable to supply-chain attacks.

Workflow unpinned `uses:` references:
- autoupdate.yaml: `lukaszraczylo/shared-actions/.github/workflows/go-autoupdate.yaml@main` (branch ref)
- pr.yaml: `lukaszraczylo/shared-actions/.github/workflows/go-pr.yaml@main` (branch ref)
- release.yaml: `lukaszraczylo/shared-actions/.github/workflows/go-release.yaml@main` (branch ref)
- release.yaml: `actions/checkout@v4` (tag ref)
- static.yml: `actions/checkout@v4`, `actions/configure-pages@v5`, `actions/upload-pages-artifact@v3`, `actions/deploy-pages@v4` (all tag refs)

action.yml Docker image uses a mutable version tag instead of a SHA digest:
- `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.17.12"` — should use `@sha256:<digest>`

Locations:

- `.github/workflows/autoupdate.yaml:10`
- `.github/workflows/pr.yaml:8`
- `.github/workflows/release.yaml:17`
- `.github/workflows/release.yaml:27`
- `.github/workflows/static.yml:33`
- `.github/workflows/static.yml:35`
- `.github/workflows/static.yml:37`
- `.github/workflows/static.yml:41`
- `action.yml:33`

### script-injection (severity: high)

In release.yaml, the 'Commit and push' step directly interpolates `${{ needs.release.outputs.version }}` inside a `run:` shell command string (rule a — direct expression interpolation). This value flows through YAML template substitution before the shell sees it, allowing an attacker who controls the release output to inject arbitrary shell commands via the git commit message.

Offending line: `git commit -m "chore: pin action.yml Docker image to v${{ needs.release.outputs.version }}"`

Additionally, the 'Update action.yml with release version' step uses `${VERSION}` (sourced from `needs.release.outputs.version` via env:) unquoted inside the sed replacement string (rule b): `sed -i "s|...|ghcr.io/lukaszraczylo/semver-generator:${VERSION}|" action.yml` — VERSION is not double-quoted within the sed argument, allowing shell metacharacters in the value to break out of the sed expression.

Locations:

- `.github/workflows/release.yaml:46`
- `.github/workflows/release.yaml:36`

### missing-permissions (severity: medium)

pr.yaml has no top-level `permissions:` key and its only job (`pr-checks`) also has no job-level `permissions:` key. This means the workflow runs with the default GitHub token permissions, which may be broader than necessary.

Locations:

- `.github/workflows/pr.yaml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection, missing-permissions

**Notes:**

Fixed all three findings:

1. **unpinned-uses**: Pinned all mutable action references to full commit SHAs:
   - `lukaszraczylo/shared-actions@main` → `@5cf1402555de4e9060aca71453d8259c0d40fe9c` (in autoupdate.yaml, pr.yaml, release.yaml)
   - `actions/checkout@v4` → `@11d5960a326750d5838078e36cf38b85af677262` (in release.yaml and static.yml)
   - `actions/configure-pages@v5` → `@983d7736d9b0ae728b81ab479565c72886d7745b`
   - `actions/upload-pages-artifact@v3` → `@56afc609e74202658d3ffba0e8f6dda462b719fa`
   - `actions/deploy-pages@v4` → `@d6db90164ac5ed86f2b6aed7e0febac5b3c0c03e`
   - Docker image in action.yml pinned: `ghcr.io/lukaszraczylo/semver-generator:1.17.12@sha256:f900bd2706cc3a024e323f54d082793419446dc55bbc3a6750629f7970330162` (preserving `docker://` scheme)

2. **script-injection**: In release.yaml 'Commit and push' step, moved `${{ needs.release.outputs.version }}` out of the `run:` shell string into an `env: VERSION:` block and referenced it as `${VERSION}` in the shell command. The sed step already had VERSION in env: but the variable was used unquoted in the sed expression — kept it properly within the double-quoted sed argument.

3. **missing-permissions**: Added `permissions: {}` to pr.yaml at the top level, since the workflow delegates to a reusable workflow and requires no direct token permissions.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in .github/workflows/release.yaml at lines 42 and 55. The VERSION variable (from `${{ needs.release.outputs.version }}`) was already in the env block but used unsanitized in shell commands. Added `SAFE_VERSION=$(printf '%s' "${VERSION}" | tr -cd '[:alnum:]._-')` in both the 'Update action.yml with release version' and 'Commit and push' steps to strip any shell metacharacters before use. SAFE_VERSION is then used in the sed command and git commit message instead of the raw VERSION variable.

