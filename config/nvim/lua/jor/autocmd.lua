vim.api.nvim_create_autocmd({"QuitPre", "BufDelete", "BufUnload"}, {
  callback = function()
    vim.cmd.wshada()
  end
})
