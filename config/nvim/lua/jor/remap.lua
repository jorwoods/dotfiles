local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- Gives a different hotkey to copy to the system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- Visual mode. Allows J and K to move selected blocks up and down.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keeps cursor in place when using "J" to append next line to current
vim.keymap.set("n", "J", "mzJ`z")

-- Keeps cursor in the middle of the screen when moving with half page jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Replace with word copied, but send cut text into the void register
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Gives a different hotkey to copy to the system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Delete to void register
vim.keymap.set("x", "<leader>d", "\"_d")

-- Ignore Q
vim.keymap.set("n", "Q", "<nop>")

-- Quick format
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)
