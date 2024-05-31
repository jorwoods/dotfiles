require("mason").setup()
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    local imap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('i', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    local telescope = require('telescope.builtin')
    nmap('gd', telescope.lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', telescope.lsp_references, '[G]oto [R]eferences')
    nmap('gi', telescope.lsp_implementations, '[G]oto [I]mplementations')
    nmap('<leader>D', telescope.lsp_type_definitions, 'Type [D]efinitions')
    nmap('<leader>ws', function ()
       vim.ui.input( { prompt = "Symbol query: (leave blank for symbol under cursor)" }, function (query)
        if (query) then
            if (query == "") then query = vim.fn.expand("<cword>") end
            telescope.lsp_workspace_symbols({
                 query = query,
                 prompt_title = ("Workspace Symbols (%s)"):format(query),
            })

        end
       end)
    end, '[W]orkspace [S]ymbols')
    nmap('<leader>gn', vim.diagnostic.goto_next, '[G]oto [N]ext Diagnostic')
    nmap('<leader>gp', vim.diagnostic.goto_prev, '[G]oto [P]revious Diagnostic')
    --  Need to find a different mapping for this due to conflict with delete keymap
    --    nmap('<leader>dl', telescope.lsp_document_diagnostics, '[D]ocument [L]inting')


    -- See `:help K` for more info
    nmap('K', vim.lsp.buf.hover, 'Show [D]ocumentation')
    -- imap('<C-k>', vim.lsp.buf.hover, 'Show [D]ocumentation')
    imap('<C-k>', function ()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({bufnr = bufnr }), { bufnr = bufnr })
    end, 'Show [D]ocumentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
    -- Create a command `:Format` local to the LSP buffer
    nmap('<leader>ff', function() vim.lsp.buf.format { async = true } end, '[f]ormat [f]ile')
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
    gopls = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdPart = false },
            telemetry = { enable = false },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                  'vim',
                  'require'
                },
              },
        },
    },
    pyright = {
        python = {
            inlay_hint = true,
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
            },
        },
    },
    ruff_lsp = {},
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

-- Configure auto completions with
-- [[ Configure nvim-cmp ]]
-- See `:help cmp` for more info

local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = {
        -- n/p for next/previous selection in completion menu
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<C-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        --        { name = 'buffer' },
    },
}
