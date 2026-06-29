#!/usr/bin/env bash

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "🔐 ${GREEN}GitHub SSH Key Setup Script${NC}"
echo "---"

if ! command -v ssh-keygen &>/dev/null; then
    echo -e "${RED}❌ Error: ssh-keygen not found. Install OpenSSH.${NC}"
    exit 1
fi

if ! command -v ssh-agent &>/dev/null; then
    echo -e "${RED}❌ Error: ssh-agent not found. Install OpenSSH.${NC}"
    exit 1
fi

if ! command -v git &>/dev/null; then
    echo -e "${RED}❌ Error: git not found. Install Git.${NC}"
    exit 1
fi

mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"

KEY_PATH="${HOME}/.ssh/id_ed25519"
EMAIL="$(git config user.email 2>/dev/null || echo "$(whoami)@$(hostname)")"

echo -e "Key will be generated at: ${YELLOW}${KEY_PATH}${NC}"
echo -e "Key comment will be: ${YELLOW}${EMAIL}${NC}"
echo "---"

if [ -f "$KEY_PATH" ]; then
    echo -e "${YELLOW}⚠️ SSH key already exists at ${KEY_PATH}${NC}"
    echo -ne "Do you want to ${RED}overwrite${NC} it? (y/N): "
    read -r choice

    case "$choice" in
        y|Y)
            echo -e "🗝️ Generating a new SSH key..."
            ;;
        *)
            echo -e "${GREEN}🚫 Aborting. Keeping existing SSH key.${NC}"
            exit 0
            ;;
    esac
fi

echo -ne "Do you want to set a passphrase? Recommended for security. (y/N): "
read -r use_passphrase_choice

PASSPHRASE=""

if [[ "$use_passphrase_choice" =~ ^[Yy]$ ]]; then
    read -s -p "Passphrase: " PASSPHRASE
    echo
    read -s -p "Confirm passphrase: " PASSPHRASE_CONFIRM
    echo

    if [ "$PASSPHRASE" != "$PASSPHRASE_CONFIRM" ]; then
        echo -e "${RED}❌ Passphrases do not match.${NC}"
        exit 1
    fi
fi

ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N "$PASSPHRASE"

chmod 600 "$KEY_PATH"
chmod 644 "${KEY_PATH}.pub"

echo -e "${GREEN}✅ SSH key generated successfully.${NC}"
echo "---"

echo "🚀 Starting ssh-agent and adding key..."
eval "$(ssh-agent -s)"

ssh-add "$KEY_PATH"

echo -e "${GREEN}✅ SSH key added to ssh-agent.${NC}"
echo "---"

PUBLIC_KEY_CONTENT="$(cat "${KEY_PATH}.pub")"

echo "📋 Copying public key to clipboard..."

if command -v pbcopy &>/dev/null; then
    echo "$PUBLIC_KEY_CONTENT" | pbcopy
    echo -e "${GREEN}✅ Copied using pbcopy.${NC}"
elif command -v xclip &>/dev/null; then
    echo "$PUBLIC_KEY_CONTENT" | xclip -selection clipboard
    echo -e "${GREEN}✅ Copied using xclip.${NC}"
elif command -v wl-copy &>/dev/null; then
    echo "$PUBLIC_KEY_CONTENT" | wl-copy
    echo -e "${GREEN}✅ Copied using wl-copy.${NC}"
else
    echo -e "${YELLOW}⚠️ Clipboard tool not found. Copy this key manually:${NC}"
    echo
    echo "$PUBLIC_KEY_CONTENT"
    echo
fi

echo "---"

GITHUB_SSH_URL="https://github.com/settings/ssh/new"

echo "🌐 Opening GitHub SSH key page..."

if command -v xdg-open &>/dev/null; then
    xdg-open "$GITHUB_SSH_URL" &>/dev/null &
elif command -v open &>/dev/null; then
    open "$GITHUB_SSH_URL" &>/dev/null &
else
    echo -e "${YELLOW}Open this URL manually:${NC}"
    echo "$GITHUB_SSH_URL"
fi

echo
echo "Paste the public key into GitHub:"
echo "GitHub → Settings → SSH and GPG keys → New SSH key"
echo

read -r -p "After adding the key to GitHub, press Enter to test the connection..."

echo "🔗 Testing SSH connection to GitHub..."

SSH_OUTPUT="$(ssh -T git@github.com 2>&1 || true)"

echo "$SSH_OUTPUT"

if echo "$SSH_OUTPUT" | grep -q "successfully authenticated"; then
    echo -e "${GREEN}✅ SSH connection to GitHub successful.${NC}"
else
    echo -e "${RED}❌ SSH connection failed.${NC}"
    echo
    echo "Run this for detailed debugging:"
    echo "ssh -vT git@github.com"
    exit 1
fi

echo "---"
echo -e "🎉 ${GREEN}GitHub SSH setup completed successfully.${NC}"
echo
echo "Now you can clone:"
echo "git clone git@github.com:Zodiac-OS/utility-scripts.git"
