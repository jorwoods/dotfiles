local oil = require("oil")

oil.setup({

})
vim.keymap.set("n", "<leader>pv", vim.cmd.Oil , { desc = 'Open project folder view' })
