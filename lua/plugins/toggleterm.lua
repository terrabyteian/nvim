-- ============================================================
-- toggleterm.lua — integrated terminal, multiple instances
-- ============================================================

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<C-t>",        "<cmd>1ToggleTerm direction=horizontal<CR>", desc = "Terminal 1",   mode = { "n", "t" } },
    { "<leader>tt",   "<cmd>TermSelect<CR>",                       desc = "Select terminal" },
  },
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    open_mapping     = nil, -- managed manually above
    hide_numbers     = true,
    shade_terminals  = true,
    shading_factor   = 2,
    start_in_insert  = true,
    insert_mappings  = false,
    persist_size     = true,
    direction        = "horizontal",
    close_on_exit    = true,
    shell            = vim.o.shell,
    float_opts = {
      border     = "curved",
      winblend   = 0,
      highlights = { border = "Normal", background = "Normal" },
    },
    -- Allow window navigation from terminal with <C-h/j/k/l>
    on_open = function(term)
      vim.cmd("startinsert!")
      -- Map <C-t> to toggle in terminal mode
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-t>",
        "<cmd>1ToggleTerm direction=horizontal<CR>",
        { noremap = true, silent = true })
    end,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Multi-terminal shortcuts: 2<C-t>, 3<C-t>
    local function set_term_keymap(n)
      vim.keymap.set("n", n .. "<C-t>",
        "<cmd>" .. n .. "ToggleTerm direction=horizontal<CR>",
        { desc = "Terminal " .. n })
    end
    for i = 2, 9 do set_term_keymap(tostring(i)) end

    -- Navigate out of terminal with <C-h/j/k/l>
    function _G.set_terminal_keymaps()
      local map = vim.api.nvim_buf_set_keymap
      local opts_t = { noremap = true, silent = true }
      map(0, "t", "<C-h>", "<cmd>wincmd h<CR>", opts_t)
      map(0, "t", "<C-j>", "<cmd>wincmd j<CR>", opts_t)
      map(0, "t", "<C-k>", "<cmd>wincmd k<CR>", opts_t)
      map(0, "t", "<C-l>", "<cmd>wincmd l<CR>", opts_t)
      map(0, "t", "<Esc>", "<C-\\><C-n>",        opts_t) -- exit insert in terminal
    end

    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
