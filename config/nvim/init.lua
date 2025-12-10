vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('jor')
require('jor.set')
require('jor.lazy')
require('jor.remap')

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = {"*.tf", "*.tfvars"},
    callback = function()
        vim.fn.jobstart({"terraform", "fmt", vim.fn.expand("%:p")}, {
            on_exit = function(_, code)
                if code ~= 0 then
                    vim.notify("Error running terraform fmt", vim.log.levels.ERROR)
                else
                    -- Reload the buffer if it's still pointing to the current file
                    local buf = vim.fn.bufnr("%")
                    if buf ~= -1 then
                        vim.cmd("edit")
                    end
                end
            end,
        })
    end,
})
