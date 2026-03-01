-- ============================================================
-- lualine.lua — status line
-- ============================================================

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme                = "catppuccin",
      globalstatus         = true,
      disabled_filetypes   = { statusline = { "dashboard", "alpha", "starter" } },
      component_separators = { left = "", right = "" },
      section_separators   = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
      },
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return "" end
            local names = {}
            for _, c in ipairs(clients) do
              table.insert(names, c.name)
            end
            return "󰒋 " .. table.concat(names, ", ")
          end,
          color = { fg = "#a6e3a1" },
        },
        "encoding",
        "fileformat",
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  },
}
