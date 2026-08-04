<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.17.10

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.17.10** was hardened automatically. 4 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple workflow files and action.yml use mutable tag/branch refs instead of pinned SHA digests, making them vulnerable to supply-chain attacks.

Failing references:
- autoupdate.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-autoupdate.yaml@main` (branch ref)
- pr.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-pr.yaml@main` (branch ref)
- release.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-release.yaml@main` (branch ref), `uses: actions/checkout@v4` (tag ref)
- static.yml: `uses: actions/checkout@v4`, `uses: actions/configure-pages@v5`, `uses: actions/upload-pages-artifact@v3`, `uses: actions/deploy-pages@v4` (all tag refs)
- action.yml: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.17.8"` uses a mutable image tag instead of a SHA digest (e.g. `ghcr.io/lukaszraczylo/semver-generator@sha256:<digest>`)

Locations:

- `.github/workflows/autoupdate.yaml:10`
- `.github/workflows/pr.yaml:13`
- `.github/workflows/release.yaml:18`
- `.github/workflows/release.yaml:30`
- `.github/workflows/static.yml:27`
- `.github/workflows/static.yml:29`
- `.github/workflows/static.yml:31`
- `.github/workflows/static.yml:35`
- `action.yml:34`

### missing-permissions (severity: medium)

pr.yaml has no top-level `permissions:` key and its only job (`pr-checks`) also has no job-level `permissions:` key. Without explicit permissions, the workflow inherits the default repository permissions, which may be overly broad (e.g. write access to contents). This is especially concerning since the workflow triggers on `pull_request` events from forks.

Locations:

- `.github/workflows/pr.yaml:1`

### script-injection (severity: high)

release.yaml contains a `run:` block that directly interpolates `${{ needs.release.outputs.version }}` into a shell command string (rule a). The git commit message is constructed with the expression inline: `git commit -m "chore: pin action.yml Docker image to v${{ needs.release.outputs.version }}"`. If the upstream `release` job's output is tampered with or contains shell metacharacters, this could lead to command injection. The value should be passed via an `env:` variable and double-quoted instead.

Locations:

- `.github/workflows/release.yaml:47`

### github-env-injection (severity: high)

In release.yaml, the `Update action.yml with release version` step sets `VERSION` from `${{ needs.release.outputs.version }}` (a workflow-controlled value) and then writes it unsanitized into action.yml via `sed -i "s|...|ghcr.io/lukaszraczylo/semver-generator:${VERSION}|"`. The `${VERSION}` value is not sanitized with `printf '%s' "$VERSION" | tr -d '\n\r'` before use. A version string containing newline characters could inject arbitrary content into action.yml, which is subsequently committed and pushed. The sanitization step is required before any write derived from workflow-controlled data.

Locations:

- `.github/workflows/release.yaml:36`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions, script-injection, github-env-injection

**Notes:**

Fixed all four findings:

1. unpinned-uses: Pinned all mutable refs to full commit SHAs:
   - autoupdate.yaml & pr.yaml & release.yaml: lukaszraczylo/shared-actions@main → @72ef4441eb6e36c1e8c5d26d91cd1a3470c63d61 # main
   - release.yaml & static.yml: actions/checkout@v4 → @11d5960a326750d5838078e36cf38b85af677262 # v4
   - static.yml: configure-pages@v5 → @983d7736..., upload-pages-artifact@v3 → @56afc609..., deploy-pages@v4 → @d6db9016...
   - action.yml: Docker image pinned with sha256 digest preserving docker:// scheme and tag

2. missing-permissions: Added `permissions: contents: read` top-level block to pr.yaml

3. script-injection: In release.yaml 'Commit and push' step, moved ${{ needs.release.outputs.version }} into env: block as VERSION, sanitized with tr -d, used ${safe_version} in commit message

4. github-env-injection: In release.yaml 'Update action.yml with release version' step, sanitized VERSION with printf/tr before using in sed command

