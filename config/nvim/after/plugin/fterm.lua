local fterm = require('FTerm')

fterm.setup({
    border = 'double',
    dimensions  = {
        height = 0.9,
        width = 0.9,
    },
})

vim.keymap.set("n", "<leader>tt", fterm.toggle, { desc = "[T]oggle [Terminal]" })
vim.keymap.set("t", "<leader>tt", fterm.toggle, { desc = "[T]oggle [Terminal]" })

