-- ============================================================
-- init.lua — entry point
-- Order matters: leader must be set before lazy loads plugins
-- ============================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")

-- ── Bootstrap lazy.nvim ─────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ── Load plugins ─────────────────────────────────────────────
require("lazy").setup({
  spec = { { import = "plugins" } },
  change_detection = { notify = false },
})

-- ── Non-plugin keymaps + autocmds (after plugins are loaded) ─
require("config.keymaps")
require("config.autocmds")
