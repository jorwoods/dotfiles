local oil = require("oil")

oil.setup({
    default_file_explorer = true,
    view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
            local ignores = {'.git', '..', '__pycache__',}
            for _,v in ipairs(ignores) do
                if name == v then
                    return true
                end
            end
            return false
        end
    }

})

vim.keymap.set("n", "<leader>pv", vim.cmd.Oil , { desc = 'Open project folder view' })
