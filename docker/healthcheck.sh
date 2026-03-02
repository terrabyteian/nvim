#!/usr/bin/env bash
# Automated health check for terrabyteian/nvim installation.
# Runs inside a container or on any machine after install.sh.
# Exit code: 0 = all passed, 1 = one or more failed.

PASS='\033[0;32m✓\033[0m'
FAIL='\033[0;31m✗\033[0m'
passed=0; failed=0

chk() {
  local desc="$1"; shift
  if "$@" &>/dev/null 2>&1; then
    echo -e "  ${PASS}  $desc"
    ((passed++)) || true
  else
    echo -e "  ${FAIL}  $desc"
    ((failed++)) || true
  fi
}

echo ""
echo "  nvim-config health check  —  $(uname -s) $(uname -m)"
echo "  ======================================================="
echo ""

echo "── system tools ─────────────────────────────────────────────"
chk "neovim 0.11+"    bash -c 'nvim --version | grep -qE "NVIM v0\.(1[1-9]|[2-9])"'
chk "ripgrep"         command -v rg
chk "fd"              command -v fd
chk "node"            command -v node
chk "go"              command -v go
chk "python3"         command -v python3
chk "pip3 / pip"      bash -c 'command -v pip3 || command -v pip'
chk "tree-sitter CLI" command -v tree-sitter
chk "git"             command -v git

echo ""
echo "── mason LSP servers ────────────────────────────────────────"
BIN="$HOME/.local/share/nvim/mason/bin"
for srv in pyright gopls rust-analyzer terraform-ls lua-language-server; do
  chk "$srv" test -x "$BIN/$srv"
done

echo ""
echo "── mason formatters ─────────────────────────────────────────"
for fmt in ruff goimports stylua; do
  chk "$fmt" test -x "$BIN/$fmt"
done

echo ""
echo "── treesitter parsers ───────────────────────────────────────"
PARSERS="$HOME/.local/share/nvim/site/parser"
for lang in lua vim python go rust bash json yaml toml markdown; do
  chk "$lang" test -f "$PARSERS/${lang}.so"
done

echo ""
echo "── summary ──────────────────────────────────────────────────"
echo "  passed: $passed"
if [ "$failed" -gt 0 ]; then
  echo -e "  \033[0;31mfailed: $failed\033[0m"
  echo ""
  exit 1
else
  echo -e "  \033[0;32mfailed: 0 — all good\033[0m"
  echo ""
fi
