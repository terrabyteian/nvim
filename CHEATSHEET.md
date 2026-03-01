# Neovim Config — Cheatsheet

## Reproduction Checklist

### 1. Install prerequisites (brew)
```sh
brew install ripgrep fd
brew install --cask font-jetbrains-mono-nerd-font
```

### 2. Set Nerd Font in your terminal
- **iTerm2**: Preferences → Profiles → Text → Font → "JetBrainsMono Nerd Font"
- **Kitty**: `font_family JetBrainsMono Nerd Font Mono`
- **Wezterm**: `font = wezterm.font("JetBrainsMono Nerd Font")`

### 3. First launch
```sh
nvim
# lazy.nvim bootstraps itself, then installs all plugins
# Wait for lazy to finish, then:
:TSUpdate          # build treesitter parsers
:Mason             # watch LSP + formatter installs
:checkhealth       # verify everything is green
```

---

## All Keybindings

**Leader key:** `<Space>`

### File Finding (Telescope)
| Key | Action |
|-----|--------|
| `<leader><leader>` | Find files (including hidden) |
| `<leader>/` | Live grep across project |
| `<leader>fb` | Find open buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fd` | Project diagnostics |
| `<leader>fg` | Git status |
| `<leader>fk` | Keymaps |
| `<leader>fc` | Commands |

### File Browser (Neo-tree)
| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file browser sidebar |
| `<leader>E` | Reveal current file in tree |
| `H` (in tree) | Toggle hidden files |
| `l` (in tree) | Open file/expand dir |
| `h` (in tree) | Close/collapse dir |
| `a` (in tree) | Add file |
| `A` (in tree) | Add directory |
| `r` (in tree) | Rename |
| `D` (in tree) | Delete |
| `/` (in tree) | Fuzzy search |

### Terminal (ToggleTerm)
| Key | Action |
|-----|--------|
| `<C-t>` | Toggle terminal 1 |
| `2<C-t>` | Toggle terminal 2 |
| `3<C-t>` | Toggle terminal 3 (etc. up to 9) |
| `<leader>tt` | Pick terminal (TermSelect) |
| `<Esc>` (in terminal) | Exit terminal insert mode |
| `<C-h/j/k/l>` (in terminal) | Navigate to adjacent window |

### LSP (buffer-local, active when LSP attaches)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gI` | Implementations |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>lf` | Format buffer |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>ld` | Show line diagnostics (float) |
| `<leader>fs` | Document symbols |
| `<leader>fw` | Workspace symbols |

### Git (Gitsigns)
| Key | Action |
|-----|--------|
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>hB` | Toggle line blame |
| `<leader>hd` | Diff this |
| `ih` (visual) | Select hunk (text object) |

### Diagnostics / Trouble
| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle project diagnostics panel |
| `<leader>xb` | Buffer diagnostics |
| `<leader>xs` | Symbols panel |
| `<leader>xl` | LSP refs/defs panel |
| `<leader>xL` | Location list |
| `<leader>xQ` | Quickfix list |

### Buffers / Windows
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate windows |
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bd` | Delete buffer |
| `<C-Up/Down/Left/Right>` | Resize splits |
| `<Esc>` (normal) | Clear search highlight |

### Completion (insert mode)
| Key | Action |
|-----|--------|
| `<Tab>` | Next completion item / expand snippet |
| `<S-Tab>` | Previous item |
| `<CR>` | Confirm selection |
| `<C-Space>` | Trigger completion manually |
| `<C-e>` | Abort completion |
| `<C-u>` / `<C-d>` | Scroll docs up/down |

### Editing Utilities
| Key | Action |
|-----|--------|
| `<` / `>` (visual) | Indent left/right (keeps selection) |
| `J` / `K` (visual) | Move selection down/up |
| `n` / `N` | Search next/prev (auto-centered) |
| `p` (visual) | Paste without overwriting register |

---

## Plugin List

| Plugin | What it does |
|--------|-------------|
| **lazy.nvim** | Plugin manager — handles installs, updates, lazy-loading |
| **catppuccin** | Color theme (Mocha dark variant) |
| **nvim-treesitter** | Accurate syntax highlighting and smart indentation via AST |
| **mason.nvim** | GUI installer for LSP servers, formatters, linters |
| **mason-lspconfig** | Bridges Mason installs with nvim-lspconfig setup |
| **mason-tool-installer** | Auto-installs specific formatter/linter tools on startup |
| **nvim-lspconfig** | Configures LSP server connections and behavior |
| **lazydev.nvim** | Teaches lua_ls the full Neovim API (Lua config editing) |
| **nvim-cmp** | Completion engine — aggregates sources and drives the menu |
| **cmp-nvim-lsp** | LSP completions source for nvim-cmp |
| **cmp-buffer** | Word completions from current buffer |
| **cmp-path** | File path completions |
| **LuaSnip** | Snippet engine with jump points |
| **cmp_luasnip** | Exposes LuaSnip snippets in nvim-cmp |
| **nvim-autopairs** | Auto-closes `()`, `[]`, `{}`, `""`, `''` |
| **conform.nvim** | Runs formatters on save (ruff, goimports, stylua, etc.) |
| **telescope.nvim** | Fuzzy finder for files, grep, buffers, LSP, and more |
| **telescope-fzf-native** | C-compiled fzf sorter — makes telescope much faster |
| **telescope-ui-select** | Routes `vim.ui.select` through telescope dropdown |
| **plenary.nvim** | Utility library required by telescope and others |
| **neo-tree.nvim** | Sidebar file browser with git status icons |
| **nvim-web-devicons** | File type icons (requires Nerd Font) |
| **nui.nvim** | UI component library required by neo-tree |
| **toggleterm.nvim** | Integrated terminal with multiple named instances |
| **gitsigns.nvim** | Git hunk gutter signs + staging + inline blame |
| **lualine.nvim** | Status line with mode, branch, diagnostics, LSP name |
| **trouble.nvim** | Structured diagnostics panel (project-wide or buffer) |
| **which-key.nvim** | Shows available keybindings in a popup after timeout |
| **indent-blankline** | Visual indent guide lines |

---

## LSP Servers + Formatters

| Language | LSP Server | Formatter | Notes |
|----------|-----------|-----------|-------|
| Python | `pyright` | `ruff_format`, `ruff_organize_imports` | ruff installed via Mason |
| Go | `gopls` | `goimports` | goimports installed via Mason |
| Rust | `rust_analyzer` | `rustfmt` | rustfmt comes with rustup, not Mason |
| Terraform | `terraformls` | `terraform_fmt` | uses system `terraform` binary |
| Lua | `lua_ls` | `stylua` | stylua installed via Mason |

---

## Useful Commands

| Command | What it does |
|---------|-------------|
| `:Mason` | Open Mason UI — install/update/remove LSP tools |
| `:MasonUpdate` | Update Mason registry |
| `:LspInfo` | Show LSP servers attached to current buffer |
| `:LspRestart` | Restart LSP servers |
| `:TSUpdate` | Update/rebuild treesitter parsers |
| `:TSInstall <lang>` | Install parser for a language |
| `:Lazy` | Open lazy.nvim UI (update plugins, view logs) |
| `:Lazy sync` | Install + update + clean all plugins |
| `:ConformInfo` | Show formatters configured for current buffer |
| `:checkhealth` | Full health check — look for red errors |
| `:checkhealth telescope` | Telescope-specific health (checks ripgrep, fd) |
| `:Neotree` | Open file browser |
| `:TermSelect` | Pick from open terminals |

---

## How-To Guide

### Add a new language
1. **Treesitter parser** — add language to `ensure_installed` in `lua/plugins/treesitter.lua`
2. **LSP server** — add server name to `ensure_installed` in both mason-lspconfig and mason-tool-installer sections in `lua/plugins/lsp.lua`, then add `lspconfig.<server>.setup({})` call
3. **Formatter** — add to `formatters_by_ft` in `lua/plugins/conform.lua`
4. Reopen nvim → `:Lazy sync` → `:Mason` to watch installs

### Change the color theme
1. Open `lua/plugins/catppuccin.lua`
2. Change `flavour` to `"latte"` (light), `"frappe"`, `"macchiato"`, or `"mocha"` (dark)
3. Or swap the entire plugin for another theme (e.g., tokyonight, gruvbox)

### Add a plugin
1. Create a new file in `lua/plugins/<name>.lua`
2. Return a lazy.nvim plugin spec table
3. Reopen nvim — lazy auto-detects and installs it

### Disable format-on-save for a filetype
In `lua/plugins/conform.lua`, remove the entry from `formatters_by_ft`.
To disable globally: remove the `format_on_save` key from opts.

### Toggle hidden files in neo-tree
Press `H` while the neo-tree sidebar is focused.

### Use multiple terminals
- `<C-t>` opens terminal 1
- `2<C-t>` opens terminal 2 (prefix with count)
- `<leader>tt` opens TermSelect to pick any open terminal

---

## First-Launch Verification

```
:TSUpdate          → parsers build without errors
:Mason             → all tools show ✓ installed
:LspInfo           → LSP attached when editing .py/.go/.rs/.tf
:ConformInfo       → formatter shown for current filetype
:checkhealth       → no red errors (warnings OK)
```

Open a file and verify:
- **Syntax highlighting** — colors look right (treesitter)
- **Completion** — type something, `<C-Space>` shows menu (LSP + nvim-cmp)
- **Format on save** — `:w` auto-formats (conform)
- **Git gutter** — edit a tracked file, `▎` appears in sign column (gitsigns)
- **File browser** — `<leader>e` opens sidebar (neo-tree)
- **Terminal** — `<C-t>` opens terminal at bottom (toggleterm)
