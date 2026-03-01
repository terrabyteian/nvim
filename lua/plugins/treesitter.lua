-- ============================================================
-- treesitter.lua — syntax highlighting + indentation + folds
--
-- nvim-treesitter v1.0 fully rewrote its API:
--   • `nvim-treesitter.configs` module removed
--   • setup() only accepts { install_dir }
--   • highlight  → vim.treesitter.start() (built-in nvim 0.11 API)
--   • indent     → nvim-treesitter.indent.get_indent()
--   • parsers    → require("nvim-treesitter.install").install()
--   • lazy = false: plugin explicitly does not support lazy-loading
--   • compilation requires `tree-sitter` CLI (npm install -g tree-sitter-cli)
--
-- IMPORTANT: install() lives in `build`, not `config`.
--   build  → runs once after plugin install/update (never on every launch)
--   config → runs on every nvim startup (only sets up FileType autocmd here)
-- ============================================================

local parsers = {
  "lua", "vim", "vimdoc",
  "python", "go", "rust", "hcl", "terraform",
  "json", "yaml", "toml", "markdown", "markdown_inline",
  "bash", "regex", "diff",
}

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- v1.0 does not support lazy-loading

  -- Runs ONLY after plugin install or update, never on regular startup.
  -- Requires tree-sitter CLI: npm install -g tree-sitter-cli
  build = function()
    require("nvim-treesitter.install").install(parsers)
  end,

  config = function()
    -- ── Enable highlight + indent per filetype ──────────────
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("Treesitter", { clear = true }),
      callback = function(args)
        local buf = args.buf

        -- Skip very large files
        local ok_stat, stat = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok_stat and stat and stat.size > 100 * 1024 then return end

        -- Enable treesitter highlight (silently fails if no parser available)
        local ok_hl = pcall(vim.treesitter.start, buf)

        -- Enable treesitter indent only when highlight succeeded
        if ok_hl then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter.indent'.get_indent(v:lnum)"
        end
      end,
    })
  end,
}
