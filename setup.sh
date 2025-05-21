#!/bin/bash

echo "Starting dotfiles setup..."

# --- Step 0: Setup and OS Detection ---
REPO_BIN_DIR="./bin"
TARGET_BIN_DIR="$HOME/bin"

# Detect platform
OS="$(uname -s)"
echo "Detected OS: $OS"
echo ""

# Check if the script is being run via ./setup.sh but not marked as executable
if [[ "$0" == "./setup.sh" && ! -x "$0" ]]; then
	echo "❌ setup.sh is not executable. Run:"
	echo "chmod +x setup.sh"
	echo "Then execute it with:"
	echo "./setup.sh"
	exit 1
fi

# --- Step 1: Ensure target bin directory exists ---
# This prevents errors during file operations
mkdir -p "$TARGET_BIN_DIR"

# --- Step 2: Clean up orphaned scripts in ~/bin ---
echo "🔍 Scanning $TARGET_BIN_DIR for orphaned scripts..."

orphan_found=false

for existing in "$TARGET_BIN_DIR/"*; do
	filename=$(basename "$existing")
	repo_script="$REPO_BIN_DIR/$filename"

	# If script no longer exists in ./bin, remove it from ~/bin
	if [[ ! -f "$repo_script" ]]; then
		rm "$existing"
		echo "🗑️ Removed: $filename"
        orphan_found=true
	fi
done

if ! $orphan_found; then
	echo "✅ No orphaned scripts found. Everything is up to date."
fi
echo ""

# --- Step 3: Install scripts from ./bin to ~/bin ---
echo "📦 Installing commands from ./bin to $TARGET_BIN_DIR..."

for script in "$REPO_BIN_DIR"/*; do
	filename=$(basename "$script")

	# Copy script and ensure it's executable
	cp "$script" "$TARGET_BIN_DIR/$filename"
	chmod +x "$TARGET_BIN_DIR/$filename"
	echo "✅ Installed $filename"
done

# Added newline echo for formatting
echo ""

# --- Step 4: Configure shell profile for PATH ---
# Choose the appropriate shell profile based on OS
if [[ "$OS" == "Darwin" ]]; then
	PROFILE="$HOME/.zshrc"
elif [[ "$OS" == MINGW* || "$OS" == MSYS* || "$OS" == CYGWIN* ]]; then
    PROFILE="$HOME/.bashrc"
else
	echo "❌ Unsupported OS: $OS"
	exit 1
fi

# --- Step 5: Ensure ~/bin is in PATH ---
echo "Confirming PATH setup..."
if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$PROFILE"; then
	echo 'export PATH="$HOME/bin:$PATH"' >> "$PROFILE"
	echo "✅ Added \$HOME/bin to PATH in $PROFILE"
else
	echo "✅ PATH already configured in $PROFILE"
fi

# --- Step 6: Final instructions ---
echo ""
echo "✅ Dotfiles setup complete."
echo ""
echo "🔁 Reload your shell to apply changes:"
echo "- Git Bash: source ~/.bashrc"
echo "- MacOS: source ~/.zshrc"
echo ""
echo "Or run: source $PROFILE"