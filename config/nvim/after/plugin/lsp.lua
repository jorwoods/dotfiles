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

end

-- lsp.setup()
require('mason-lspconfig').setup({
  -- Replace the language servers listed here
  -- with the ones you want to install
  ensure_installed = {
	'lua_ls', -- lua
	'marksman', -- markdown
	'pyright', -- python
	'tsserver', -- javascript
	'taplo', -- toml
	'terraformls', -- terraform
	'html', -- html
	'cssls', -- css
	'bashls', -- bash
  },
--   handlers = {
--     lsp.default_setup,
--   }
})
