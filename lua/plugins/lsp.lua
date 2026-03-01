-- ============================================================
-- lsp.lua — Mason + mason-lspconfig + nvim-lspconfig + lazydev
--
-- nvim 0.11 deprecated require('lspconfig').server.setup().
-- New API:
--   vim.lsp.config('server', { ... })  — register custom config
--   vim.lsp.enable('server')           — activate for matching filetypes
--
-- IMPORTANT ordering: vim.lsp.config() calls MUST happen BEFORE
-- mason-lspconfig.setup() which triggers vim.lsp.enable() via
-- automatic_enable. Everything is consolidated in one config fn.
-- ============================================================

return {
  -- ── lazydev: Neovim API awareness for lua_ls ──────────────
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- ── Mason: LSP / formatter / linter installer UI ──────────
  {
    "mason-org/mason.nvim",
    cmd   = "Mason",
    build = ":MasonUpdate",
    opts  = {
      ui = {
        icons = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- ── Auto-install formatters + linters ─────────────────────
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "pyright",
        "gopls",
        "rust-analyzer",
        "terraform-ls",
        "lua-language-server",
        "ruff",
        "goimports",
        "stylua",
      },
      auto_update  = false,
      run_on_start = true,
    },
  },

  -- ── nvim-lspconfig: provides default server configs ───────
  -- (cmd, filetypes, root_dir) for each server via after/lsp/*.lua
  -- We do NOT call require('lspconfig').server.setup() — deprecated.
  { "neovim/nvim-lspconfig" },

  -- ── Core LSP setup — everything in one config function ────
  -- vim.lsp.config() must run BEFORE mason-lspconfig.setup()
  -- so that custom configs are registered before servers enable.
  {
    "mason-org/mason-lspconfig.nvim",
    -- No event trigger: load at startup so LSP is ready before any buffer
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()

      -- ── 1. Capabilities (include nvim-cmp completions) ────
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- Apply capabilities to ALL servers as a default
      vim.lsp.config("*", { capabilities = capabilities })

      -- ── 2. Per-server custom settings ─────────────────────
      -- These merge on top of nvim-lspconfig's default configs.

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses    = { unusedparams = true },
            staticcheck = true,
            gofumpt     = true,
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      -- ── 3. mason-lspconfig: install + auto-enable servers ─
      -- automatic_enable = true → calls vim.lsp.enable() for each
      -- installed server using the configs we just registered above.
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "gopls",
          "rust_analyzer",
          "terraformls",
          "lua_ls",
        },
        automatic_enable = true,
      })

      -- ── 4. LspAttach: buffer-local keymaps ────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local tel_ok, tel = pcall(require, "telescope.builtin")

          map("gd",         tel_ok and tel.lsp_definitions    or vim.lsp.buf.definition,     "Go to definition")
          map("gD",         vim.lsp.buf.declaration,                                           "Go to declaration")
          map("gr",         tel_ok and tel.lsp_references      or vim.lsp.buf.references,     "References")
          map("gI",         tel_ok and tel.lsp_implementations or vim.lsp.buf.implementation, "Implementations")
          map("K",          vim.lsp.buf.hover,                                                 "Hover docs")
          map("<leader>ca", vim.lsp.buf.code_action,                                           "Code action")
          map("<leader>rn", vim.lsp.buf.rename,                                                "Rename symbol")
          map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end,               "Format buffer")
          map("[d",         function() vim.diagnostic.jump({ count = -1, float = true }) end,  "Prev diagnostic")
          map("]d",         function() vim.diagnostic.jump({ count =  1, float = true }) end,  "Next diagnostic")
          map("<leader>ld", vim.diagnostic.open_float,                                         "Line diagnostics")
          map("<leader>fs", tel_ok and tel.lsp_document_symbols  or vim.lsp.buf.document_symbol,  "Document symbols")
          map("<leader>fw", tel_ok and tel.lsp_workspace_symbols or vim.lsp.buf.workspace_symbol, "Workspace symbols")
        end,
      })

      -- ── 5. Diagnostics display ────────────────────────────
      vim.diagnostic.config({
        virtual_text    = { prefix = "●" },
        signs           = true,
        underline       = true,
        update_in_insert = false,
        severity_sort   = true,
        float = {
          focusable = false,
          style     = "minimal",
          border    = "rounded",
          source    = "always",
        },
      })

      -- Sign column icons
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    end,
  },
}
