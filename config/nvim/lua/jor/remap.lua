local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {desc = 'Open project folder view' })

vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = 'Navigate files tracked in git' })
vim.keymap.set("n", "<leader>ps", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = 'Regex search within git tracked files' })

-- Visual mode. Allows J and K to move selected blocks up and down.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move block down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move block up' })

-- Keeps cursor in place when using "J" to append next line to current
vim.keymap.set("n", "J", "mzJ`z", { desc = 'Append next line to current' })

-- Keeps cursor in the middle of the screen when moving with half page jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Move screen down by half page' })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Move screen up by half page' })

-- Replace with word copied, but send cut text into the void register
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = 'Replace with copied, sending cut text to void' })

-- Gives a different hotkey to copy to the system clipboard
-- Gives a different hotkey to copy to the system clipboard
vim.keymap.set("n", "<leader>y", "\"+y", { desc = 'Yank to system clipboard' })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = 'Yank to system clipboard' })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = 'Yank to system clipboard' })

-- Delete to void register
vim.keymap.set("x", "<leader>d", "\"_d", { desc = 'Delete and send to void' })

-- Ignore Q
vim.keymap.set("n", "Q", "<nop>")

-- Quick format
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)
