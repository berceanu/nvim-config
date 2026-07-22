-- General-purpose autocommands.

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local grp = augroup("UserAutocmds", { clear = true })

-- Keep splits balanced when the terminal window is resized.
autocmd("VimResized", {
  group = grp,
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. tab)
  end,
})

-- Briefly highlight yanked text.
autocmd("TextYankPost", {
  group = grp,
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Restore the last cursor position when reopening a file.
autocmd("BufReadPost", {
  group = grp,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
