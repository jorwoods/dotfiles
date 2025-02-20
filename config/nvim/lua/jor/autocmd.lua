vim.api.nvim_create_autocmd({"QuitPre", "BufWipeout", "BufLeave"}, {
  -- pattern = {"*.c", "*.h"},
  callback = function(ev)
    vim.cmd.wshada()
  end
})
