-- ============================================================
-- keymaps.lua — non-plugin keymaps
-- Plugin keymaps live in their respective plugin files
-- ============================================================

local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window navigation
map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })

-- Buffer navigation
map("n", "<leader>bn", "<cmd>bnext<CR>",     { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>",   { desc = "Delete buffer" })

-- Better indent in visual mode (keep selection)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered on search navigation
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Paste without overwriting register in visual
map("v", "p", '"_dP', { desc = "Paste without yanking selection" })

-- Resize splits with arrow keys
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Increase window height" })
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Decrease window height" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- ── Cheatsheet ───────────────────────────────────────────────
local function open_cheatsheet()
  local path = vim.fn.stdpath("config") .. "/CHEATSHEET.md"
  local buf  = vim.api.nvim_create_buf(false, true) -- unlisted, scratch

  -- Load file content
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok or #lines == 0 then
    vim.notify("Cheatsheet not found: " .. path, vim.log.levels.ERROR)
    return
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Buffer options
  vim.bo[buf].filetype    = "markdown"
  vim.bo[buf].modifiable  = false
  vim.bo[buf].bufhidden   = "wipe"   -- clean up on close

  -- Floating window dimensions (~85% of screen)
  local width  = math.floor(vim.o.columns * 0.85)
  local height = math.floor(vim.o.lines   * 0.85)
  local row    = math.floor((vim.o.lines   - height) / 2)
  local col    = math.floor((vim.o.columns - width)  / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative  = "editor",
    width     = width,
    height    = height,
    row       = row,
    col       = col,
    style     = "minimal",
    border    = "rounded",
    title     = "  Cheatsheet  ",
    title_pos = "center",
  })

  -- Window options for clean reading
  vim.wo[win].wrap          = true
  vim.wo[win].linebreak     = true
  vim.wo[win].conceallevel  = 2  -- hide markdown syntax markers (##, **, etc.)
  vim.wo[win].concealcursor = "n"
  vim.wo[win].scrolloff     = 4

  -- q or <Esc> to close
  local close = "<cmd>close<CR>"
  vim.keymap.set("n", "q",     close, { buffer = buf, silent = true, nowait = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, silent = true })
end

vim.api.nvim_create_user_command("Cheatsheet", open_cheatsheet, { desc = "Open cheatsheet" })
map("n", "<leader>?", open_cheatsheet, { desc = "Cheatsheet" })
