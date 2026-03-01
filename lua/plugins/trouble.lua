-- ============================================================
-- trouble.lua — diagnostics panel
-- ============================================================

return {
  "folke/trouble.nvim",
  cmd  = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",                        desc = "Diagnostics (Trouble)" },
    { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",           desc = "Buffer diagnostics (Trouble)" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<CR>",                            desc = "Location list (Trouble)" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<CR>",                             desc = "Quickfix list (Trouble)" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>",                desc = "Symbols (Trouble)" },
    { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP refs/defs (Trouble)" },
  },
  opts = {
    modes = {
      diagnostics = {
        auto_open  = false,
        auto_close = true,
      },
    },
  },
}
