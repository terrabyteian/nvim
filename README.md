# nvim config

Personal Neovim 0.11 config. IDE feel for Python, Go, Rust, Terraform.

## Install (one command)

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.sh)
```

Then open `nvim` and wait for plugins to finish installing.

### What the script installs

| Tool | Purpose |
|------|---------|
| Neovim 0.11+ | via Homebrew (macOS) or GitHub release tarball (Linux) |
| ripgrep | telescope live grep |
| fd | telescope file finder |
| Node.js | required by pyright (Python LSP) |
| JetBrainsMono Nerd Font | icons in file tree, statusline, telescope |

> **After install:** set your terminal font to `JetBrainsMono Nerd Font Mono`.
> Icons won't render until you do this.

## After first launch

```
:TSUpdate       build treesitter parsers
:Mason          watch LSP + formatter installs
:checkhealth    verify everything is green
```

## Supported platforms

- macOS (Apple Silicon + Intel)
- Linux x86_64 (Debian/Ubuntu, Fedora/RHEL, Arch, openSUSE)

## Keybindings

Open the cheatsheet from inside nvim: `<Space>?`

## Language support

| Language | LSP | Formatter |
|----------|-----|-----------|
| Python | pyright | ruff |
| Go | gopls | goimports |
| Rust | rust_analyzer | rustfmt (via rustup) |
| Terraform | terraformls | terraform fmt |
| Lua | lua_ls | stylua |

> Rust requires `rustup` — install at https://rustup.rs
> Terraform requires the `terraform` binary in PATH

## Adding a language

1. Add the treesitter parser name to `lua/plugins/treesitter.lua` → `parsers` list
2. Add the LSP server to `lua/plugins/lsp.lua` → `ensure_installed` in both mason-lspconfig and mason-tool-installer, then add a `vim.lsp.config()` call if you need custom settings
3. Add the formatter to `lua/plugins/conform.lua` → `formatters_by_ft`
4. Reopen nvim → `:Lazy sync` → `:Mason`
