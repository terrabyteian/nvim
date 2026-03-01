-- ============================================================
-- which-key.lua — keymap hint popup
-- ============================================================

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay  = 300,
    icons  = {
      breadcrumb = "»",
      separator  = "➜",
      group      = "+",
    },
    spec = {
      -- Group labels for <leader> prefixes
      { "<leader>f",  group = "find" },
      { "<leader>b",  group = "buffer" },
      { "<leader>h",  group = "git hunks" },
      { "<leader>l",  group = "lsp" },
      { "<leader>x",  group = "diagnostics/trouble" },
      { "<leader>t",  group = "terminal" },
      { "<leader>?",  desc  = "Cheatsheet" },
    },
  },
}
