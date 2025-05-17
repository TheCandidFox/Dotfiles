#!/bin/bash

ROOT=$(cd "$(git rev-parse --show-toplevel)" && pwd -P)
GITIGNORE="$ROOT/.gitignore"

for INPUT in "$@"; do
  TARGET=$(realpath -m "$INPUT")
  REL_PATH="${TARGET#$ROOT/}"
  REL_PATH="${REL_PATH%/}/"

  grep -qxF "$REL_PATH" "$GITIGNORE" || echo "$REL_PATH" >> "$GITIGNORE"
  echo "✅ Ignored $REL_PATH"
done

