#!/usr/bin/env bash
# Point Claude Code at the Router One gateway by appending two exports to
# your shell profile. Idempotent: refuses to write duplicates, asks first.
#
# Usage: ./setup-claude-code.sh sk-your-router-one-key
set -euo pipefail

BASE_URL="https://api.router.one"
KEY="${1:-}"

if [[ -z "$KEY" ]]; then
  echo "Usage: $0 sk-your-router-one-key"
  echo "Get a key at https://router.one (Dashboard -> API Keys)"
  exit 1
fi

case "${SHELL:-}" in
  */zsh) PROFILE="$HOME/.zshrc" ;;
  */bash) PROFILE="$HOME/.bashrc" ;;
  *) PROFILE="$HOME/.profile" ;;
esac

if grep -qs "ANTHROPIC_BASE_URL=$BASE_URL" "$PROFILE"; then
  echo "Router One is already configured in $PROFILE — nothing to do."
  exit 0
fi

echo "This will append to $PROFILE:"
echo
echo "  export ANTHROPIC_BASE_URL=$BASE_URL"
echo "  export ANTHROPIC_AUTH_TOKEN=$KEY"
echo
read -r -p "Continue? [y/N] " answer
if [[ ! "$answer" =~ ^[Yy]$ ]]; then
  echo "Aborted. To configure this shell only, run:"
  echo "  export ANTHROPIC_BASE_URL=$BASE_URL"
  echo "  export ANTHROPIC_AUTH_TOKEN=$KEY"
  exit 0
fi

{
  echo ""
  echo "# Claude Code via Router One (https://router.one)"
  echo "export ANTHROPIC_BASE_URL=$BASE_URL"
  echo "export ANTHROPIC_AUTH_TOKEN=$KEY"
} >> "$PROFILE"

echo "Done. Open a new terminal (or 'source $PROFILE') and run: claude"
