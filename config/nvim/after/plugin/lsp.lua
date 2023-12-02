require("mason").setup()
-- local lsp = require('lsp-zero')
-- lsp.on_attach(function(client, bufnr)
-- 	local opts = {buffer = bufnr, remap = false}

-- 	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
-- 	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
-- 	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
-- 	vim.keymap.set("n", "<leader>vd", function() vim.lsp.buf.open_float() end, opts)
-- 	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
-- 	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
-- 	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
-- 	vim.keymap.set("n", "[d", function() vim.lsp.buf.goto_next() end, opts)
-- 	vim.keymap.set("n", "]d", function() vim.lsp.buf.goto_prev() end, opts)
-- 	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

-- end)

local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, {buffer=bufnr, desc=desc})
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    telescope = require('telescope.builtin')
    nmap('gd', telescope.lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', telescope.lsp_references, '[G]oto [R]eferences')
    nmap('gi', telescope.lsp_implementations, '[G]oto [I]mplementations')
    nmap('<leader>D', telescope.lsp_type_definitions, 'Type [D]efinitions')
    nmap('<leader>ws', telescope.lsp_workspace_symbols, '[W]orkspace [S]ymbols')
    nmap('<leader>gn', vim.diagnostic.goto_next, '[G]oto [N]ext Diagnostic')
    nmap('<leader>gp', vim.diagnostic.goto_previous, '[G]oto [N]ext Diagnostic')
--  Need to find a different mapping for this due to conflict with delete keymap
--    nmap('<leader>dl', telescope.lsp_document_diagnostics, '[D]ocument [L]inting')

    
    -- See `:help K` for more info
    nmap('K', vim.lsp.buf.hover, 'Show [D]ocumentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

-- lsp.setup()
local mason_lspconfig = require('mason-lspconfig')


local servers = {
    marksman = {},
    tsserver = {},
    taplo = {},
    terraformls = {},
    html = {},
    cssls = {},
    bashls = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdPart = false },
            telemetry = { enable = false },
        },
    },
    pyright = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
            },
        },
    },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = servers[server_name] or {},
            filetypes = (servers[server_name] or {}).filetypes,
        }
    end
}



