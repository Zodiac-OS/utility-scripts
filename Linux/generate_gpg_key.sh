#!/usr/bin/env bash

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔐 GitHub GPG Key Setup Script"
echo "---"

if ! command -v git &>/dev/null; then
    echo -e "${RED}❌ Error: git command not found.${NC}"
    exit 1
fi

if ! command -v gpg &>/dev/null; then
    echo -e "${RED}❌ Error: gpg command not found. Please install GnuPG.${NC}"
    exit 1
fi

GIT_NAME="$(git config --global user.name || true)"
GIT_EMAIL="$(git config --global user.email || true)"

if [ -z "$GIT_NAME" ] || [ -z "$GIT_EMAIL" ]; then
    echo -e "${RED}❌ Git user name or email not configured.${NC}"
    echo "Set them using:"
    echo "  git config --global user.name 'Your Name'"
    echo "  git config --global user.email 'you@example.com'"
    exit 1
fi

echo "👤 Name:  ${GIT_NAME}"
echo "📧 Email: ${GIT_EMAIL}"
echo "---"

echo -ne "Generate a GPG key for ${YELLOW}${GIT_NAME} <${GIT_EMAIL}>${NC}? (y/N): "
read -r confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborting."
    exit 0
fi

echo "⚙️ Generating GPG key..."

GPG_BATCH_FILE="$(mktemp)"
trap 'rm -f "$GPG_BATCH_FILE"' EXIT

cat > "$GPG_BATCH_FILE" <<EOF
%no-protection
Key-Type: RSA
Key-Length: 4096
Name-Real: ${GIT_NAME}
Name-Email: ${GIT_EMAIL}
Expire-Date: 0
%commit
EOF

gpg --batch --generate-key "$GPG_BATCH_FILE"

KEY_ID="$(
    gpg --list-secret-keys --keyid-format=long "$GIT_EMAIL" 2>/dev/null \
    | awk '/^sec/ {print $2}' \
    | cut -d'/' -f2 \
    | tail -n1
)"

if [ -z "$KEY_ID" ]; then
    echo -e "${RED}❌ Could not find generated GPG key.${NC}"
    exit 1
fi

echo -e "🔑 GPG key ID: ${BOLD_GREEN}${KEY_ID}${NC}"
echo "---"

echo "⚙️ Configuring Git to sign commits..."
git config --global user.signingkey "$KEY_ID"
git config --global commit.gpgsign true
git config --global gpg.format gpg

echo -e "${GREEN}✅ Git configured to sign commits with key ${KEY_ID}.${NC}"
echo "---"

echo "📋 Exporting public GPG key..."

PUBLIC_KEY="$(gpg --armor --export "$KEY_ID")"

if command -v pbcopy &>/dev/null; then
    echo "$PUBLIC_KEY" | pbcopy
    echo -e "${GREEN}✅ Public GPG key copied using pbcopy.${NC}"
elif command -v xclip &>/dev/null; then
    echo "$PUBLIC_KEY" | xclip -selection clipboard
    echo -e "${GREEN}✅ Public GPG key copied using xclip.${NC}"
elif command -v wl-copy &>/dev/null; then
    echo "$PUBLIC_KEY" | wl-copy
    echo -e "${GREEN}✅ Public GPG key copied using wl-copy.${NC}"
else
    echo -e "${YELLOW}⚠️ Clipboard tool not found. Copy this key manually:${NC}"
    echo
    echo "$PUBLIC_KEY"
    echo
fi

echo "---"

GITHUB_KEYS_URL="https://github.com/settings/keys"

echo "🌐 Opening GitHub key settings page..."

if command -v xdg-open &>/dev/null; then
    xdg-open "$GITHUB_KEYS_URL" &>/dev/null &
elif command -v open &>/dev/null; then
    open "$GITHUB_KEYS_URL" &>/dev/null &
else
    echo "Open this URL manually:"
    echo "$GITHUB_KEYS_URL"
fi

echo
echo -e "${GREEN}✅ GPG key setup completed.${NC}"
echo
echo "Next steps:"
echo "1. Add the copied key in GitHub → Settings → SSH and GPG keys → New GPG key"
echo "2. Test with:"
echo "   git commit -S -m 'Signed commit'"
echo
echo "Your public key ID is:"
echo -e "${BOLD_GREEN}${KEY_ID}${NC}"
