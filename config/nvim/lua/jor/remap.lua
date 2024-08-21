local builtin = require('telescope.builtin')
local set = vim.keymap.set

set("n", "<C-p>", builtin.git_files, { desc = 'Navigate files tracked in git' })

-- Visual mode. Allows J and K to move selected blocks up and down.
set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move block down' })
set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move block up' })

-- Keeps cursor in place when using "J" to append next line to current
set("n", "J", "mzJ`z", { desc = 'Append next line to current' })

-- Keeps cursor in the middle of the screen when moving with half page jumps
set("n", "<C-d>", "<C-d>zz", { desc = 'Move screen down by half page' })
set("n", "<C-u>", "<C-u>zz", { desc = 'Move screen up by half page' })

-- Replace with word copied, but send cut text into the void register
set("x", "<leader>pr", "\"_dP", { desc = 'Replace with copied, sending cut text to void' })

-- Gives a different hotkey to copy to the system clipboard
set({ "n", "v" }, "<leader>y", "\"+y", { desc = 'Yank to system clipboard' })
set("n", "<leader>Y", "\"+Y", { desc = 'Yank to system clipboard' })

-- Delete to void register
set("n", "<leader>dd", "\"_d", { desc = 'Delete and send to void' })
set("n", "<leader><leader>c", "\"_c", { desc = 'Change and send to void' })

-- Paste from system clipboard
set("n", "<leader>pp", "\"+p", { desc = 'Paste from system clipboard' })

-- Ignore Q
set("n", "Q", "<nop>")

-- golang error handling
set("n", "<leader>ee", "oif err != nil {<CR>}<ESC>Oreturn err<ESC>",{ desc = "Insert golang error handler" })

-- These mappings control the size of splits (height/width)
set("n", "<M-,>", "<c-w>5<", { desc = "Increase split width" })
set("n", "<M-.>", "<c-w>5>", { desc = "Decrease split width" })
set("n", "<M-Up>", "<C-W>+", { desc = "Increase split height" })
set("n", "<M-Down>", "<C-W>-", { desc = "Decrease split height" })

-- lua execution
set("n", "<leader>x", "<cmd>.lua<CR>", { desc = 'Execute lua line' })
set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = 'Execute lua line' })

-- Replace

set("n", "r", function ()
    local register = vim.fn.input("Enter register:")
    local motion = vim.fn.input("Enter motion:")

    vim.cmd('normal! "rd' .. motion)
    vim.cmd('normal! h"' .. register .. 'p')

end, { desc = '[r]eplace motion with given register' })

