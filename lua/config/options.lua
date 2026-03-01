-- ============================================================
-- options.lua — vim.opt settings
-- ============================================================

local opt = vim.opt

-- Line numbers
opt.number         = true
opt.relativenumber = true

-- Tabs / indentation
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.smartindent    = true

-- Search
opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = true

-- UI
opt.termguicolors  = true
opt.cursorline     = true
opt.signcolumn     = "yes"   -- always show; prevents layout shift
opt.wrap           = false
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.pumheight      = 10      -- max completion menu items

-- Splits (VSCode direction)
opt.splitbelow     = true
opt.splitright     = true

-- Files
opt.undofile       = true
opt.swapfile       = false
opt.backup         = false

-- Clipboard — system clipboard
opt.clipboard      = "unnamedplus"

-- Timing
opt.updatetime     = 250    -- faster gitsigns / CursorHold
opt.timeoutlen     = 300    -- which-key responsive

-- Folds — treesitter-based, start fully open
opt.foldmethod     = "expr"
opt.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel      = 99

-- Misc
opt.mouse          = "a"
opt.showmode       = false   -- lualine shows the mode
opt.breakindent    = true
opt.list           = true
opt.listchars      = { tab = "» ", trail = "·", nbsp = "␣" }
