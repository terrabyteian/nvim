-- ============================================================
-- completion.lua — nvim-cmp + LuaSnip + autopairs
-- ============================================================

return {
  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    opts = { history = true, updateevents = "TextChanged,TextChangedI" },
  },

  -- Auto-close brackets and quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true }, -- treesitter-aware
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp      = require("cmp")
      local luasnip  = require("luasnip")
      local autopairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")

      -- Hook autopairs into cmp confirm
      if autopairs_ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end

      -- Load friendly-snippets if available
      pcall(require, "luasnip.loaders.from_vscode")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        completion = { completeopt = "menu,menuone,noinsert" },

        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-d>"]     = cmp.mapping.scroll_docs(4),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        }),

        formatting = {
          format = function(entry, item)
            local kind_icons = {
              Text          = "", Method        = "󰆧", Function      = "󰊕",
              Constructor   = "", Field         = "󰇽", Variable      = "󰂡",
              Class         = "󰠱", Interface     = "", Module        = "",
              Property      = "󰜢", Unit          = "", Value         = "󰎠",
              Enum          = "", Keyword       = "󰌋", Snippet       = "",
              Color         = "󰏘", File          = "󰈙", Reference     = "",
              Folder        = "󰉋", EnumMember    = "", Constant      = "󰏿",
              Struct        = "", Event         = "", Operator      = "󰆕",
              TypeParameter = "󰅲",
            }
            item.kind = string.format("%s %s", kind_icons[item.kind] or "", item.kind)
            item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip  = "[Snip]",
              buffer   = "[Buf]",
              path     = "[Path]",
            })[entry.source.name]
            return item
          end,
        },
      })
    end,
  },
}
