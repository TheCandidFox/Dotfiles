#!/bin/bash

# Check if the script is being run via ./setup.sh but not marked as executable
if [[ "$0" == "./setup.sh" && ! -x "$0" ]]; then
  echo "setup.sh is not executable. Run:"
  echo "chmod +x setup.sh"
  echo "Then execute it with:"
  echo "./setup.sh"
  exit 1
fi

echo "Starting dotfiles setup..."

# Detect platform
OS="$(uname -s)"
echo "Detected OS: $OS"
echo ""

# Ensure ~/bin exists
mkdir -p "$HOME/bin"

# OLD / FIRST CP and CHMOD script to get "git ignore" to work
# Copy the script (safe even if it already exists)
#cp ./bin/git-ignore "$HOME/bin/"
#chmod +x "$HOME/bin/git-ignore"


# New Looping script
# Copy the script (safe even if it already exists)
# Add scripts here for execution purposes
echo "Installing commands"
for script in ./bin/*; do
  filename=$(basename "$script")

  cp "$script" "$HOME/bin/$filename"
  chmod +x "$HOME/bin/$filename"

  echo "✅ Installed $filename"
done

# Added newline echo for formatting
echo ""

# Choose the right shell profile to update
if [[ "$OS" == "Darwin" ]]; then
    PROFILE="$HOME/.zshrc"
elif [[ "$OS" == "Linux" || "$OS" == "MINGW64_NT"* ]]; then
    PROFILE="$HOME/.bashrc"
else
    echo "ERROR"
    echo "Unsupported OS: $OS"
    exit 1
fi

# Add ~/bin to PATH if not already added
echo "Confirmations"
if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$PROFILE"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$PROFILE"
    echo "✅ Added \$HOME/bin to PATH in $PROFILE"
else
    echo "✅ PATH already configured in $PROFILE"
fi

echo "✅ Dotfiles setup complete."
echo ""
echo "Reload your shell (Git Bash: source ~/.bashrc || MacOS: source ~/.zshrc) or run:"
echo "source $PROFILE"

