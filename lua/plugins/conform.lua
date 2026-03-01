-- ============================================================
-- conform.lua — format on save
-- ============================================================

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd   = { "ConformInfo" },
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      python     = { "ruff_format", "ruff_organize_imports" },
      go         = { "goimports" },
      rust       = { "rustfmt" },          -- system rustfmt via rustup
      terraform  = { "terraform_fmt" },    -- system terraform binary
      tf         = { "terraform_fmt" },
      lua        = { "stylua" },
      json       = { "prettier" },
      yaml       = { "prettier" },
      markdown   = { "prettier" },
      sh         = { "shfmt" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    -- Don't error if formatter is missing
    notify_on_error = true,
  },
}
