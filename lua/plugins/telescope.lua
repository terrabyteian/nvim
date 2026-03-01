-- ============================================================
-- telescope.lua — fuzzy finding
-- ============================================================

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<leader><leader>", "<cmd>Telescope find_files<CR>",              desc = "Find files" },
    { "<leader>/",        "<cmd>Telescope live_grep<CR>",               desc = "Live grep" },
    { "<leader>fb",       "<cmd>Telescope buffers<CR>",                 desc = "Find buffers" },
    { "<leader>fh",       "<cmd>Telescope help_tags<CR>",               desc = "Help tags" },
    { "<leader>fr",       "<cmd>Telescope oldfiles<CR>",                desc = "Recent files" },
    { "<leader>fc",       "<cmd>Telescope commands<CR>",                desc = "Commands" },
    { "<leader>fd",       "<cmd>Telescope diagnostics<CR>",             desc = "Diagnostics" },
    { "<leader>fg",       "<cmd>Telescope git_status<CR>",              desc = "Git status" },
    { "<leader>fk",       "<cmd>Telescope keymaps<CR>",                 desc = "Keymaps" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond  = function() return vim.fn.executable("make") == 1 end,
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions   = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display     = { "truncate" },
        sorting_strategy = "ascending",
        layout_config    = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          vertical   = { mirror = false },
          width      = 0.87,
          height     = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
          },
          n = {
            ["q"]     = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          -- show hidden files, exclude .git
          find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
        },
        live_grep = {
          additional_args = { "--hidden" },
        },
      },
      extensions = {
        fzf = {
          fuzzy                   = true,
          override_generic_sorter = true,
          override_file_sorter    = true,
          case_mode               = "smart_case",
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Load extensions (pcall: gracefully handle if fzf didn't compile)
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
  end,
}
