--local map = function(lhs, rhs, desc)
--    if desc then
--        desc = "[DAP] " .. desc
--    end
--
--    vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
--end
--
--dap = require("dap")
--
--map("<leader>dr", dap.repl.open, "Open REPL")
--map("<leader>db", dap.toggle_breakpoint, "Toggle breakpoint")
--map("<leader>dB", function()
--    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
--end, "Set breakpoint condition")
--
--map("<F1>", dap.step_back, "Step back")
--map("<F2>", dap.step_into, "Step into")
--map("<F3>", dap.step_over, "Step over")
--map("<F4>", dap.step_out, "Step out")
--map("<F5>", dap.continue, "Continue")
--
local has_dap, dap = pcall(require, "dap")
if not has_dap then
    return
end

vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "🟢", texthl = "Error", linehl = "", numhl = "" })

require("nvim-dap-virtual-text").setup({
    enabled = true,
    virtual_text = true,
    underline = true,
    update_events = "TextChanged",
    spacing = 4,
})


dap.configurations.lua = {
    {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
        host = function()
            return '127.0.0.1'
        end,
        port = function()
            return 12345
        end,
    },
}

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
            return "/usr/bin/python3"
        end,
    },
}



