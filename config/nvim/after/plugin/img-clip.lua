local img = require("img-clip")

vim.keymap.set("n", "<leader>pi", img.paste_image, { desc = "[P]aste [i]mage from system clipboard" })
