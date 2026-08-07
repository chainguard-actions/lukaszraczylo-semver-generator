<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.16.5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.16.5** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple workflow files and action.yml use unpinned (mutable) references instead of full 40-character SHA commit digests:

- .github/workflows/static.yml: `actions/checkout@v4`, `actions/configure-pages@v5`, `actions/upload-pages-artifact@v3`, `actions/deploy-pages@v4` — all tag-based refs
- .github/workflows/autoupdate.yaml: `lukaszraczylo/shared-actions/.github/workflows/go-autoupdate.yaml@main` — branch ref
- .github/workflows/pr.yaml: `lukaszraczylo/shared-actions/.github/workflows/go-pr.yaml@main` — branch ref
- .github/workflows/release.yaml: `lukaszraczylo/shared-actions/.github/workflows/go-release.yaml@main` — branch ref
- action.yml: `image: "docker://ghcr.io/lukaszraczylo/semver-generator:latest"` — mutable `:latest` tag instead of a SHA digest

Mutable tags and branch refs can be silently updated by a third party to inject malicious code into the workflow.

Locations:

- `.github/workflows/static.yml:32`
- `.github/workflows/static.yml:34`
- `.github/workflows/static.yml:36`
- `.github/workflows/static.yml:40`
- `.github/workflows/autoupdate.yaml:9`
- `.github/workflows/pr.yaml:13`
- `.github/workflows/release.yaml:14`
- `action.yml:33`

### missing-permissions (severity: medium)

The workflow file .github/workflows/pr.yaml has no top-level `permissions:` key and its only job (`pr-checks`) also has no job-level `permissions:` key. Without an explicit permissions block, the job inherits the repository's default token permissions, which may be overly broad (e.g., `contents: write`). A minimal permissions block (e.g., `permissions: read-all` or specific scopes) should be added.

Locations:

- `.github/workflows/pr.yaml:1`

### github-env-injection (severity: high)

In entrypoint.sh, the variable `CLEAN_SEMVER` is derived from the output of the `semver-generator` binary, which processes user-controlled inputs (e.g., `$INPUT_REPOSITORY_URL`, `$INPUT_CONFIG_FILE`, `$INPUT_REPOSITORY_BRANCH`) that are inherited from the calling workflow. The value is written directly to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' "$CLEAN_SEMVER" | tr -d '\n\r'`). A malicious repository or input value could inject newlines into `$GITHUB_OUTPUT`, causing environment variable injection for downstream steps.

Offending line: `echo "semantic_version=$CLEAN_SEMVER" >> $GITHUB_OUTPUT`

Locations:

- `entrypoint.sh:57`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions, github-env-injection

**Notes:**

Fixed all three findings:
1. unpinned-uses: Pinned all action references to full SHA digests in static.yml (4 actions), autoupdate.yaml, pr.yaml, release.yaml (all using lukaszraczylo/shared-actions@main → @72ef4441eb6e36c1e8c5d26d91cd1a3470c63d61), and pinned the docker image in action.yml to ghcr.io/lukaszraczylo/semver-generator:latest@sha256:0555533a9125223ebda6534e20bd50dd7243c25381557fb319bc5d5b5203766c with the docker:// scheme preserved.
2. missing-permissions: Added `permissions: contents: read` top-level block to pr.yaml.
3. github-env-injection: In entrypoint.sh, sanitized CLEAN_SEMVER with `printf '%s' "$CLEAN_SEMVER" | tr -d '\n\r'` before writing to $GITHUB_OUTPUT, and quoted $GITHUB_OUTPUT.

