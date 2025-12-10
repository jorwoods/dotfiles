vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = '[G]it [S]tatus' });
vim.keymap.set("n", "<leader>gb", function()
    vim.cmd("Git blame")
end, { desc = '[G]it [B]lame' });
