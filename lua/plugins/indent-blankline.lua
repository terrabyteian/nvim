-- ============================================================
-- indent-blankline.lua — indent guides
-- ============================================================

return {
  "lukas-reineke/indent-blankline.nvim",
  main  = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts  = {
    indent = {
      char      = "│",
      tab_char  = "│",
      highlight = "IblIndent",
    },
    scope = {
      enabled   = true,
      highlight = "IblScope",
      show_start = false,
      show_end   = false,
    },
    exclude = {
      filetypes = {
        "help", "dashboard", "neo-tree", "Trouble", "trouble",
        "lazy", "mason", "notify", "toggleterm", "lazyterm",
      },
    },
  },
}
