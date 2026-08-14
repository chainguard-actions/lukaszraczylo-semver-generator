<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.17.18

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.17.18** was hardened automatically. 3 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple workflow files and action.yml use mutable tag/branch refs instead of pinned SHA digests, making them vulnerable to supply-chain attacks.

action.yml: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.17.16"` — uses a mutable tag instead of a SHA digest.

autoupdate.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-autoupdate.yaml@main` — branch ref.

pr.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-pr.yaml@main` — branch ref.

release.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-release.yaml@main` — branch ref; `uses: actions/checkout@v4` — tag ref.

static.yml: `uses: actions/checkout@v4`, `uses: actions/configure-pages@v5`, `uses: actions/upload-pages-artifact@v3`, `uses: actions/deploy-pages@v4` — all tag refs.

Locations:

- `action.yml:34`
- `.github/workflows/autoupdate.yaml:10`
- `.github/workflows/pr.yaml:8`
- `.github/workflows/release.yaml:19`
- `.github/workflows/release.yaml:31`
- `.github/workflows/static.yml:33`
- `.github/workflows/static.yml:35`
- `.github/workflows/static.yml:37`
- `.github/workflows/static.yml:41`

### missing-permissions (severity: medium)

The workflow file pr.yaml has no top-level `permissions:` key and no job-level `permissions:` key on any of its jobs. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad.

Locations:

- `.github/workflows/pr.yaml:1`

### script-injection (severity: high)

In release.yaml, two `run:` blocks directly interpolate GitHub Actions expressions into shell commands:

(a) Sub-rule (a) — direct expression interpolation: The 'Commit and push' step uses `${{ needs.release.outputs.version }}` directly inside a `git commit -m` shell command string: `git commit -m "chore: pin action.yml Docker image to v${{ needs.release.outputs.version }}"`. This expression is substituted by the Actions runner before the shell sees it, allowing injection of shell metacharacters.

(b) Sub-rule (b) — unquoted shell variable expansion: The 'Update action.yml with release version' step sets `VERSION: ${{ needs.release.outputs.version }}` in its `env:` block, then uses `${VERSION}` unquoted inside a `sed` command: `sed -i "s|...|ghcr.io/lukaszraczylo/semver-generator:${VERSION}|" action.yml`. An unquoted expansion inside a double-quoted sed expression still allows shell metacharacter injection from the version value.

Locations:

- `.github/workflows/release.yaml:36`
- `.github/workflows/release.yaml:47`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions, script-injection

**Notes:**

Fixed all three findings:

1. unpinned-uses: Pinned all mutable refs to full commit SHAs:
   - action.yml: docker://ghcr.io/lukaszraczylo/semver-generator:1.17.16 → pinned with @sha256:cb1fe9f8213d0cf66ff7c56a5d5c836f769a95b519848e84b6dfa97fb8b45a6e
   - autoupdate.yaml: go-autoupdate.yaml@main → @5cf1402555de4e9060aca71453d8259c0d40fe9c # main
   - pr.yaml: go-pr.yaml@main → @5cf1402555de4e9060aca71453d8259c0d40fe9c # main
   - release.yaml: go-release.yaml@main → @5cf1402555de4e9060aca71453d8259c0d40fe9c # main; actions/checkout@v4 → @11d5960a326750d5838078e36cf38b85af677262 # v4
   - static.yml: actions/checkout@v4, configure-pages@v5, upload-pages-artifact@v3, deploy-pages@v4 all pinned to full SHAs

2. missing-permissions: Added `permissions: {}` top-level block to pr.yaml.

3. script-injection: In release.yaml 'Commit and push' step, moved `${{ needs.release.outputs.version }}` out of the shell run string into an env var `RELEASE_VERSION`, then referenced it as `${RELEASE_VERSION}` in the git commit message.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed both script injection findings in .github/workflows/release.yaml:
1. Line 40 ('Update action.yml with release version' step): Added sanitization of VERSION before use in sed command — `SAFE_VERSION="$(printf '%s' "${VERSION}" | tr -cd 'a-zA-Z0-9.\-')"` strips all characters except alphanumerics, dots, and hyphens, preventing sed metacharacter injection.
2. Line 52 ('Commit and push' step): Added sanitization of RELEASE_VERSION before use in git commit message — `SAFE_RELEASE_VERSION="$(printf '%s' "${RELEASE_VERSION}" | tr -cd 'a-zA-Z0-9.\-')"` strips all shell metacharacters, preventing command injection via the commit message string.

