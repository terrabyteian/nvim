-- ============================================================
-- neo-tree.lua — sidebar file browser
-- ============================================================

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd    = "Neotree",
  keys   = {
    { "<leader>e", "<cmd>Neotree toggle<CR>",             desc = "Toggle file browser" },
    { "<leader>E", "<cmd>Neotree reveal<CR>",             desc = "Reveal file in tree" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    close_if_last_window    = true,
    enable_git_status       = true,
    enable_diagnostics      = true,
    open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
    default_component_configs = {
      indent = {
        indent_size         = 2,
        padding             = 1,
        with_markers        = true,
        indent_marker       = "│",
        last_indent_marker  = "└",
        highlight           = "NeoTreeIndentMarker",
      },
      icon = {
        folder_closed  = "",
        folder_open    = "",
        folder_empty   = "󰜌",
        default        = "*",
        highlight      = "NeoTreeFileIcon",
      },
      modified = { symbol = "[+]", highlight = "NeoTreeModified" },
      name     = { trailing_slash = false, use_git_status_colors = true, highlight = "NeoTreeFileName" },
      git_status = {
        symbols = {
          added     = "✚",  modified  = "",   deleted   = "✖",
          renamed   = "󰁕",  untracked = "",   ignored   = "",
          unstaged  = "󰄱",  staged    = "",   conflict  = "",
        },
      },
    },
    window = {
      position = "left",
      width    = 35,
      mappings = {
        ["<space>"] = "none", -- don't shadow leader
        ["H"]       = "toggle_hidden",
        ["l"]       = "open",
        ["h"]       = "close_node",
        ["/"]       = "fuzzy_finder",
        ["D"]       = "delete",
        ["r"]       = "rename",
        ["y"]       = "copy_to_clipboard",
        ["x"]       = "cut_to_clipboard",
        ["p"]       = "paste_from_clipboard",
        ["a"]       = { "add", config = { show_path = "none" } },
        ["A"]       = "add_directory",
        ["?"]       = "show_help",
        ["<"]       = "prev_source",
        [">"]       = "next_source",
      },
    },
    nesting_rules = {},
    filesystem = {
      filtered_items = {
        visible        = false, -- hidden files not shown by default; toggle with H
        hide_dotfiles  = true,
        hide_gitignored = true,
        hide_hidden    = true,   -- macOS hidden files
        never_show     = { ".DS_Store", "thumbs.db" },
      },
      follow_current_file = { enabled = true },
      group_empty_dirs    = false,
      use_libuv_file_watcher = true,
    },
    buffers = {
      follow_current_file = { enabled = true },
    },
    git_status = {
      window = { position = "float" },
    },
  },
}
