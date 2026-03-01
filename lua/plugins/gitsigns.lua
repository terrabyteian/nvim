-- ============================================================
-- gitsigns.lua — git gutter signs + hunk actions
-- ============================================================

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "▁" },
      topdelete    = { text = "▔" },
      changedelete = { text = "▎" },
      untracked    = { text = "▎" },
    },
    signcolumn          = true,
    numhl               = false,
    linehl              = false,
    word_diff           = false,
    watch_gitdir        = { follow_files = true },
    attach_to_untracked = true,
    current_line_blame  = false, -- toggle with <leader>hb
    current_line_blame_opts = {
      virt_text          = true,
      virt_text_pos      = "eol",
      delay              = 1000,
      ignore_whitespace  = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority    = 6,
    update_debounce  = 100,
    status_formatter = nil,
    max_file_length  = 40000,
    preview_config   = {
      border   = "rounded",
      style    = "minimal",
      relative = "cursor",
      row      = 0,
      col      = 1,
    },

    on_attach = function(bufnr)
      local gs  = require("gitsigns")
      local map = function(mode, keys, func, desc)
        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "Git: " .. desc })
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, "Next hunk")

      map("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, "Prev hunk")

      -- Actions
      map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>",   "Stage hunk")
      map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>",   "Reset hunk")
      map("n",          "<leader>hS", gs.stage_buffer,              "Stage buffer")
      map("n",          "<leader>hu", gs.undo_stage_hunk,           "Undo stage hunk")
      map("n",          "<leader>hR", gs.reset_buffer,              "Reset buffer")
      map("n",          "<leader>hp", gs.preview_hunk,              "Preview hunk")
      map("n",          "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
      map("n",          "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")
      map("n",          "<leader>hd", gs.diffthis,                  "Diff this")
      map("n",          "<leader>hD", function() gs.diffthis("~") end, "Diff this ~")

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
    end,
  },
}
