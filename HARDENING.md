<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.17.20

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.17.20** was hardened automatically. 3 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple workflow files and action.yml reference actions and Docker images by mutable tags or branch names instead of pinned SHA digests, making them vulnerable to supply-chain attacks.

- autoupdate.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-autoupdate.yaml@main` (branch ref)
- pr.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-pr.yaml@main` (branch ref)
- release.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-release.yaml@main` (branch ref); `uses: actions/checkout@v4` (tag)
- static.yml: `uses: actions/checkout@v4`, `uses: actions/configure-pages@v5`, `uses: actions/upload-pages-artifact@v3`, `uses: actions/deploy-pages@v4` (all tags)
- action.yml: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.17.18"` (mutable tag, not a SHA digest)

Locations:

- `.github/workflows/autoupdate.yaml:8`
- `.github/workflows/pr.yaml:8`
- `.github/workflows/release.yaml:17`
- `.github/workflows/release.yaml:30`
- `.github/workflows/static.yml:24`
- `.github/workflows/static.yml:26`
- `.github/workflows/static.yml:28`
- `.github/workflows/static.yml:32`
- `action.yml:34`

### script-injection (severity: high)

Sub-rule (a): In release.yaml, the 'Commit and push' step directly interpolates `${{ needs.release.outputs.version }}` inside a `run:` shell command string. This expression is expanded by the GitHub Actions template engine before the shell sees it, allowing a malicious version string to inject arbitrary shell commands.

Offending line: `git commit -m "chore: pin action.yml Docker image to v${{ needs.release.outputs.version }}"`

Locations:

- `.github/workflows/release.yaml:47`

### missing-permissions (severity: medium)

The workflow file pr.yaml has no top-level `permissions:` key and the single job `pr-checks` also has no job-level `permissions:` key. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad (write access to contents by default on many repositories).

Locations:

- `.github/workflows/pr.yaml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection, missing-permissions

**Notes:**

Fixed all three findings: (1) Pinned all mutable action references to full commit SHAs in autoupdate.yaml, pr.yaml, release.yaml, and static.yml; pinned the Docker image in action.yml to its SHA digest while preserving the docker:// scheme and tag. (2) Fixed script injection in release.yaml's 'Commit and push' step by moving ${{ needs.release.outputs.version }} into an env: block and referencing it as ${VERSION} in the shell. (3) Added 'permissions: contents: read' to pr.yaml which had no permissions block.

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in .github/workflows/release.yaml at lines 42 and 56. In both the 'Update action.yml with release version' and 'Commit and push' steps, added a sanitization step: `VERSION_SAFE=$(printf '%s' "${VERSION}" | tr -d '\n\r|;\`$')` that strips newlines, pipe characters (sed delimiter), semicolons, backticks, and dollar signs from the workflow-controllable VERSION value. All subsequent uses of VERSION in sed and git commit commands now reference the sanitized VERSION_SAFE variable.

