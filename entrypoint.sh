#!/bin/bash
set -e

FLAGS=()

if [[ -z "$INPUT_CONFIG_FILE" ]]; then
  echo "Set the configuration file path."
  exit 1
else
  FLAGS+=("-c" "$INPUT_CONFIG_FILE")
fi

if [[ -z "$INPUT_REPOSITORY_URL" ]] && [[ -z "$INPUT_REPOSITORY_LOCAL" ]];
then
  echo "You need to set either remote repository or repository local flags."
fi

if [[ ! -z "$INPUT_REPOSITORY_URL" ]]; then
  FLAGS+=("-r" "$INPUT_REPOSITORY_URL")
fi

if [[ ! -z "$INPUT_REPOSITORY_BRANCH" ]]; then
  FLAGS+=("-b" "$INPUT_REPOSITORY_BRANCH")
fi

if [[ ! -z "$INPUT_REPOSITORY_LOCAL" ]]; then
  FLAGS+=("-l")
fi

if [[ ! -z "$INPUT_STRICT" ]]; then
  FLAGS+=("-s")
fi

if [[ ! -z "$INPUT_EXISTING" ]]; then
  FLAGS+=("-e")
fi

if [[ ! -z "$INPUT_DEBUGMODE" ]]; then
  FLAGS+=("--debug")
fi

if [[ "${#FLAGS[@]}" -eq 0 && "$*" == "" ]]; then
  exit 1
fi

if [[ ! -z "$INPUT_GITHUB_TOKEN" ]]; then
  export GITHUB_TOKEN=$INPUT_GITHUB_TOKEN
fi

if [[ ! -z "$INPUT_GITHUB_USERNAME" ]]; then
  export GITHUB_USERNAME=$INPUT_GITHUB_USERNAME
fi

if [[ ! -z "$INPUT_DEBUGMODE" ]]; then
  echo "DEBUG MODE ENABLED"
  echo "----"
  ls -lA
  echo "----"
  pwd
  echo "----"
  echo "FLAGS: ${FLAGS[*]}"
  echo "----"
  /go/src/app/semver-generator generate "${FLAGS[@]}" "$@"
  echo "----"
fi

OUT_SEMVER_GEN=$(/go/src/app/semver-generator generate "${FLAGS[@]}" "$@")
[ $? -eq 0 ] || exit 1
CLEAN_SEMVER=$(echo "$OUT_SEMVER_GEN" | sed -e 's|SEMVER ||g')
safe=$(printf '%s' "$CLEAN_SEMVER" | tr -d '\n\r')
echo "semantic_version=$safe" >> "$GITHUB_OUTPUT"
echo "$OUT_SEMVER_GEN"
