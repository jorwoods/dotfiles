local builtin = require('telescope.builtin')
pcall(builtin.load_extension, 'fzf')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '[P]roject [f]iles' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = '[P]roject git [f]iles' })
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = '[P]roject [s]earch' })
