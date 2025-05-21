#!/bin/bash

# --- Step 0: Setup ---
REPO_BIN_DIR="./bin"
TARGET_BIN_DIR="$HOME/bin"
DRY_RUN=true

# --- Step 1: Optional --no-dry-run flag ---
if [[ "$1" == "--no-dry-run" ]]; then
	DRY_RUN=false
	echo "🚨 Dry run disabled — files WILL be deleted!"
else
	echo "🧪 Running in dry run mode — no files will be deleted."
	echo "Use './bin-cleanup.sh --no-dry-run' to apply deletions."
fi

# --- Step 2: Loop through files in $HOME/bin and compare to ./bin ---
echo ""
echo "🔍 Scanning $TARGET_BIN_DIR for orphaned scripts..."

for existing in "$TARGET_BIN_DIR/"*; do
	filename=$(basename "$existing")
	repo_script="$REPO_BIN_DIR/$filename"

	if [[ ! -f "$repo_script" ]]; then
		if $DRY_RUN; then
			echo "🟡 Would remove: $filename"
		else
			rm "$existing"
			echo "🗑️ Removed: $filename"
		fi
	fi
done
