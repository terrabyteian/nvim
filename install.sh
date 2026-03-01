#!/usr/bin/env bash
# =============================================================
# install.sh — one-shot setup for terrabyteian/nvim
#
# Usage (on a fresh machine):
#   bash <(curl -fsSL https://raw.githubusercontent.com/terrabyteian/nvim/main/install.sh)
#
# What this does:
#   1. Installs Neovim 0.11+, ripgrep, fd, Node.js, tree-sitter CLI,
#      git, unzip, JetBrainsMono Nerd Font
#   2. Backs up any existing ~/.config/nvim
#   3. Clones this repo to ~/.config/nvim
#   4. Prints next steps
# =============================================================

set -euo pipefail

REPO_URL="https://github.com/terrabyteian/nvim"
NVIM_CONFIG="$HOME/.config/nvim"
MIN_NVIM_MINOR=11   # require 0.11+

# ── Colors ────────────────────────────────────────────────────
B='\033[0;34m'; G='\033[0;32m'; Y='\033[1;33m'; R='\033[0;31m'; N='\033[0m'
log()  { echo -e "${B}=>${N} $1"; }
ok()   { echo -e "${G}✓${N}  $1"; }
warn() { echo -e "${Y}⚠${N}  $1"; }
die()  { echo -e "${R}✗${N}  $1"; exit 1; }

nvim_is_new_enough() {
  command -v nvim &>/dev/null || return 1
  local minor
  minor=$(nvim --version | head -1 | sed 's/NVIM v[0-9]*\.\([0-9]*\).*/\1/')
  [ "${minor:-0}" -ge "$MIN_NVIM_MINOR" ]
}

# ── macOS ─────────────────────────────────────────────────────
install_macos() {
  log "macOS detected"

  if ! command -v brew &>/dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to PATH for Apple Silicon
    if [ -f /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi

  log "Installing packages via Homebrew..."
  # git and unzip are provided by macOS/Xcode tools; no brew formula needed
  brew install neovim ripgrep fd node
  ok "neovim, ripgrep, fd, node installed"

  log "Installing tree-sitter CLI..."
  # nvim-treesitter v1.0 requires 'tree-sitter build' to compile parsers.
  # 'brew install tree-sitter' is only the C library, not the CLI binary.
  npm install -g tree-sitter-cli
  ok "tree-sitter CLI installed"

  log "Installing JetBrainsMono Nerd Font..."
  brew install --cask font-jetbrains-mono-nerd-font
  ok "JetBrainsMono Nerd Font installed"

  echo ""
  warn "ACTION REQUIRED: Open your terminal preferences and set the font to"
  warn "  'JetBrainsMono Nerd Font Mono'  (or similar variant)"
  warn "Icons will not render correctly until you do this."
}

# ── Linux ─────────────────────────────────────────────────────
install_linux() {
  log "Linux detected ($(uname -m))"

  if [ "$(uname -m)" != "x86_64" ]; then
    die "This script only supports x86_64 Linux. Detected: $(uname -m)"
  fi

  install_nvim_linux
  install_tools_linux   # ripgrep, fd, git, unzip
  install_node_linux    # node.js
  install_treesitter_cli_linux  # tree-sitter CLI (needs node)
  install_font_linux    # JetBrainsMono Nerd Font
}

install_nvim_linux() {
  if nvim_is_new_enough; then
    ok "Neovim $(nvim --version | head -1 | cut -d' ' -f2) already installed"
    return
  fi

  log "Installing Neovim (latest stable) from GitHub releases..."
  local tmp
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz" \
    -o "$tmp/nvim.tar.gz"

  mkdir -p "$HOME/.local"
  tar -C "$HOME/.local" --strip-components=1 -xzf "$tmp/nvim.tar.gz"
  rm -rf "$tmp"

  export PATH="$HOME/.local/bin:$PATH"

  if ! command -v nvim &>/dev/null; then
    warn "~/.local/bin is not in your PATH."
    warn "Add this to your shell rc file (~/.bashrc or ~/.zshrc):"
    warn '  export PATH="$HOME/.local/bin:$PATH"'
  fi

  ok "Neovim $(nvim --version | head -1 | cut -d' ' -f2) installed to ~/.local/bin"
}

install_tools_linux() {
  log "Installing ripgrep, fd, git, unzip..."

  if command -v apt &>/dev/null; then
    sudo apt update -qq
    sudo apt install -y ripgrep fd-find git unzip
    # Debian/Ubuntu installs fd as 'fdfind' — symlink to 'fd'
    if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
      mkdir -p "$HOME/.local/bin"
      ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    fi

  elif command -v dnf &>/dev/null; then
    sudo dnf install -y ripgrep fd git unzip

  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm ripgrep fd git unzip

  elif command -v zypper &>/dev/null; then
    sudo zypper install -y ripgrep fd git unzip

  else
    warn "Unknown package manager — installing ripgrep + fd from GitHub releases..."
    local tmp
    tmp=$(mktemp -d)
    mkdir -p "$HOME/.local/bin"

    # ripgrep
    local rg_ver
    rg_ver=$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
      | grep '"tag_name"' | sed 's/.*"tag_name": *"\(.*\)".*/\1/')
    curl -fsSL "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep-${rg_ver}-x86_64-unknown-linux-musl.tar.gz" \
      | tar -C "$tmp" -xz
    cp "$tmp"/ripgrep-*/rg "$HOME/.local/bin/"

    # fd
    local fd_ver
    fd_ver=$(curl -fsSL https://api.github.com/repos/sharkdp/fd/releases/latest \
      | grep '"tag_name"' | sed 's/.*"tag_name": *"\(.*\)".*/\1/')
    curl -fsSL "https://github.com/sharkdp/fd/releases/latest/download/fd-${fd_ver}-x86_64-unknown-linux-musl.tar.gz" \
      | tar -C "$tmp" -xz
    cp "$tmp"/fd-*/fd "$HOME/.local/bin/"

    rm -rf "$tmp"

    # git and unzip are typically available; warn if not
    command -v git   &>/dev/null || warn "git not found — install it manually"
    command -v unzip &>/dev/null || warn "unzip not found — install it manually"
  fi

  ok "ripgrep, fd, git, unzip ready"
}

install_node_linux() {
  if command -v node &>/dev/null; then
    ok "Node.js $(node --version) already installed"
    return
  fi

  log "Installing Node.js (LTS)..."

  if command -v apt &>/dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y nodejs npm
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm nodejs npm
  else
    warn "Could not install Node.js automatically."
    warn "Install it manually from https://nodejs.org — required for pyright (Python LSP)"
    warn "and tree-sitter CLI (treesitter parser compilation)."
    return
  fi

  ok "Node.js $(node --version) installed"
}

install_treesitter_cli_linux() {
  # Runs after install_node_linux — node must be available.
  # nvim-treesitter v1.0 requires 'tree-sitter build' to compile parsers.
  if ! command -v node &>/dev/null; then
    warn "Node.js not available — skipping tree-sitter CLI install."
    warn "Install node then run: npm install -g tree-sitter-cli"
    return
  fi

  log "Installing tree-sitter CLI..."
  npm install -g tree-sitter-cli
  ok "tree-sitter CLI installed"
}

install_font_linux() {
  log "Installing JetBrainsMono Nerd Font..."
  local font_dir="$HOME/.local/share/fonts/JetBrainsMono"
  mkdir -p "$font_dir"

  local tmp
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
    -o "$tmp/JetBrainsMono.zip"

  unzip -qo "$tmp/JetBrainsMono.zip" -d "$font_dir"
  rm -rf "$tmp"

  fc-cache -f "$font_dir" 2>/dev/null || true
  ok "JetBrainsMono Nerd Font installed to $font_dir"

  echo ""
  warn "ACTION REQUIRED: Set your terminal font to 'JetBrainsMono Nerd Font Mono'"
  warn "Icons will not render correctly until you do this."
}

# ── Clone config ──────────────────────────────────────────────
clone_config() {
  # Already running from the cloned config (e.g. manual setup)
  if [ -f "$NVIM_CONFIG/init.lua" ] && [ -d "$NVIM_CONFIG/.git" ]; then
    ok "Config already present at $NVIM_CONFIG"
    return
  fi

  command -v git &>/dev/null || die "git is required but not installed"

  # Back up existing non-git config
  if [ -e "$NVIM_CONFIG" ]; then
    local backup="${NVIM_CONFIG}.bak.$(date +%s)"
    warn "Existing config found — backing up to $backup"
    mv "$NVIM_CONFIG" "$backup"
  fi

  log "Cloning config to $NVIM_CONFIG..."
  git clone "$REPO_URL" "$NVIM_CONFIG"
  ok "Config cloned"
}

# ── Main ──────────────────────────────────────────────────────
main() {
  echo ""
  echo "  Neovim config installer"
  echo "  ========================"
  echo ""

  local os
  os=$(uname -s)

  case "$os" in
    Darwin) install_macos ;;
    Linux)  install_linux ;;
    *)      die "Unsupported OS: $os" ;;
  esac

  clone_config

  echo ""
  echo -e "${G}All done!${N} Next steps:"
  echo ""
  echo "  1. Set your terminal font to 'JetBrainsMono Nerd Font Mono'"
  echo "  2. Open nvim — plugins + treesitter parsers install automatically"
  echo "     (first launch takes ~60s to compile parsers; subsequent launches are instant)"
  echo "  3. Inside nvim, run:  :Mason      (watch LSP installs finish)"
  echo "  4. Inside nvim, run:  :checkhealth"
  echo ""
  echo "  Keybindings reference:  <leader>?  (Space + ?)"
  echo ""
}

main "$@"
