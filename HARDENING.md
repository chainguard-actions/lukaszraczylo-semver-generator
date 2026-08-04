<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.17.8

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.17.8** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple workflow files reference actions and reusable workflows using mutable tags or branch names instead of full 40-character commit SHAs, making them vulnerable to supply-chain attacks.

autoupdate.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-autoupdate.yaml@main` (branch ref)
pr.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-pr.yaml@main` (branch ref)
release.yaml: `uses: lukaszraczylo/shared-actions/.github/workflows/go-release.yaml@main` (branch ref), `uses: actions/checkout@v4` (tag ref)
static.yml: `uses: actions/checkout@v4`, `uses: actions/configure-pages@v5`, `uses: actions/upload-pages-artifact@v3`, `uses: actions/deploy-pages@v4` (all tag refs)

Additionally, action.yml references a Docker image by mutable tag instead of SHA digest:
`image: "docker://ghcr.io/lukaszraczylo/semver-generator:1.17.6"` — should use a `@sha256:<digest>` reference.

Locations:

- `.github/workflows/autoupdate.yaml:8`
- `.github/workflows/pr.yaml:13`
- `.github/workflows/release.yaml:19`
- `.github/workflows/release.yaml:32`
- `.github/workflows/static.yml:30`
- `.github/workflows/static.yml:32`
- `.github/workflows/static.yml:34`
- `.github/workflows/static.yml:38`
- `action.yml:39`

### permissions (severity: medium)

missing-permissions: pr.yaml has no top-level `permissions:` key and its only job (`pr-checks`) also has no job-level `permissions:` key. Without explicit permissions, the workflow inherits the default repository permissions (which may include write access), violating the principle of least privilege.

Locations:

- `.github/workflows/pr.yaml:1`

### script-injection (severity: high)

Rule (a) violation: In the 'Commit and push' step of release.yaml, the expression `${{ needs.release.outputs.version }}` is directly interpolated inside a `run:` shell command string. This causes the value to be substituted into the shell command before the shell parses it, enabling script injection if the value contains shell metacharacters.

Offending line:
  `git commit -m "chore: pin action.yml Docker image to v${{ needs.release.outputs.version }}"`

The value should be passed via an `env:` variable and the variable reference double-quoted in the shell script instead.

Locations:

- `.github/workflows/release.yaml:54`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, permissions, script-injection

**Notes:**

Fixed all three findings:
1. unpinned-uses: Pinned all mutable action references to full 40-char SHAs in autoupdate.yaml, pr.yaml, release.yaml, and static.yml. Also pinned the Docker image in action.yml to its sha256 digest while preserving the docker:// scheme and tag.
2. permissions: Added top-level `permissions: { contents: read, pull-requests: read }` block to pr.yaml.
3. script-injection: In release.yaml 'Commit and push' step, moved `${{ needs.release.outputs.version }}` out of the run: shell string into an env: block as VERSION, then referenced it as ${VERSION} in the shell script.

