#!/bin/bash

# Check if the script is being run via ./setup.sh but not marked as executable
if [[ "$0" == "./setup.sh" && ! -x "$0" ]]; then
  echo "⚠️  setup.sh is not executable. Run:"
  echo "   chmod +x setup.sh"
  echo "Then execute it with:"
  echo "   ./setup.sh"
  exit 1
fi

echo "��� Starting dotfiles setup..."

# Detect platform
OS="$(uname -s)"
echo "���️  Detected OS: $OS"

# Ensure ~/bin exists
mkdir -p "$HOME/bin"

# Copy the script (safe even if it already exists)
cp ./bin/git-ignore "$HOME/bin/"
chmod +x "$HOME/bin/git-ignore"

# Choose the right shell profile to update
if [[ "$OS" == "Darwin" ]]; then
    PROFILE="$HOME/.zshrc"
elif [[ "$OS" == "Linux" || "$OS" == "MINGW64_NT"* ]]; then
    PROFILE="$HOME/.bashrc"
else
    echo "⚠️ Unsupported OS: $OS"
    exit 1
fi

# Add ~/bin to PATH if not already added
if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$PROFILE"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$PROFILE"
    echo "��� Added \$HOME/bin to PATH in $PROFILE"
else
    echo "✅ PATH already configured in $PROFILE"
fi

echo "✅ Dotfiles setup complete. Reload your shell or run:"
echo "source $PROFILE"

