-- ============================================================
-- catppuccin.lua — theme
-- ============================================================

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before other plugins
  opts = {
    flavour = "mocha",
    background = { light = "latte", dark = "mocha" },
    transparent_background = false,
    integrations = {
      treesitter      = true,
      native_lsp      = { enabled = true },
      cmp             = true,
      gitsigns        = true,
      telescope       = { enabled = true },
      neotree         = true,
      which_key       = true,
      indent_blankline = { enabled = true },
      lualine         = true,
      trouble         = true,
      mason           = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
