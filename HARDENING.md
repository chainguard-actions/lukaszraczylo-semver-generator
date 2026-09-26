<!-- markdownlint-disable -->

# Hardening Report: lukaszraczylo--semver-generator/v1.18.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lukaszraczylo--semver-generator/v1.18.2** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The action.yml uses a Docker image reference with a mutable tag (`docker://ghcr.io/lukaszraczylo/semver-generator:1.17.20`) instead of an immutable SHA digest. This means the image could be silently replaced with a malicious version without any change to the action definition, enabling a supply-chain attack. It should be pinned to a full SHA256 digest, e.g. `ghcr.io/lukaszraczylo/semver-generator@sha256:<64-hex-char-digest>`

Locations:

- `action.yml:38`

### github-env-injection (severity: high)

In entrypoint.sh, the variable `$CLEAN_SEMVER` is written to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). `CLEAN_SEMVER` is derived from the output of the semver-generator binary, which is invoked with `$FLAGS` — a string built from workflow-controlled inherited env vars (`$INPUT_CONFIG_FILE`, `$INPUT_REPOSITORY_URL`, `$INPUT_REPOSITORY_BRANCH`, etc.). A malicious caller could craft input that embeds newlines in the binary's output, injecting arbitrary key=value pairs into `$GITHUB_OUTPUT` and potentially overwriting subsequent step outputs. The fix is to sanitize before writing: `safe=$(printf '%s' "$CLEAN_SEMVER" | tr -d '\n\r'); echo "semantic_version=$safe" >> $GITHUB_OUTPUT`

Locations:

- `entrypoint.sh:57`

### script-injection (severity: high)

Rule (b) violation: entrypoint.sh passes the unquoted shell variable `$FLAGS` directly to shell command invocations on lines 52 and 55 (`/go/src/app/semver-generator generate $FLAGS $*`). `$FLAGS` is constructed by concatenating workflow-controlled inherited env vars (`$INPUT_CONFIG_FILE`, `$INPUT_REPOSITORY_URL`, `$INPUT_REPOSITORY_BRANCH`) without quoting. An attacker-controlled value containing shell metacharacters (`;`, `|`, `&`, `$(...)`, whitespace, glob chars) could break out of the intended argument context and execute arbitrary commands. All expansions of `$FLAGS` should be double-quoted: `"/go/src/app/semver-generator" generate "$FLAGS" "$@"`. Additionally, `$INPUT_CONFIG_FILE` and `$INPUT_REPOSITORY_URL` are appended to `$FLAGS` unquoted (e.g. `FLAGS="${FLAGS} -c $INPUT_CONFIG_FILE"`), compounding the risk.

Locations:

- `entrypoint.sh:10`
- `entrypoint.sh:19`
- `entrypoint.sh:23`
- `entrypoint.sh:52`
- `entrypoint.sh:55`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection, github-env-injection

**Notes:**

1. action.yml: Pinned Docker image 'docker://ghcr.io/lukaszraczylo/semver-generator:1.17.20' to immutable digest 'docker://ghcr.io/lukaszraczylo/semver-generator:1.17.20@sha256:f45d1bf6bc06b3260567b481f340e52857b1eadd343e43d23a87b1d0dc9f930b', preserving the docker:// scheme and tag. 2. entrypoint.sh (script-injection): Replaced the string-based FLAGS variable with a bash array (FLAGS=()), adding each flag and its value as separate quoted array elements (e.g., FLAGS+=("-c" "$INPUT_CONFIG_FILE")). The binary is now invoked with "${FLAGS[@]}" "$@" instead of unquoted $FLAGS $*. 3. entrypoint.sh (github-env-injection): Added sanitization of CLEAN_SEMVER before writing to $GITHUB_OUTPUT using 'safe=$(printf '%s' "$CLEAN_SEMVER" | tr -d '\n\r')' and writing 'semantic_version=$safe' to prevent newline injection.

