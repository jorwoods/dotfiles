-- vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4 -- 1 tab = 4 spaces
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4 -- shift 4 spaces when tab
vim.opt.expandtab = true -- Use spaces instead of tab
vim.opt.smartindent = true -- Autoindent newlines
vim.opt.foldcolumn = '2'

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true


vim.opt.hlsearch = true
vim.opt.incsearch = true -- Show match as its being typed
vim.opt.ignorecase = true -- Make searches case insensitive
vim.opt.smartcase = true -- Make search case matter if any letter is capital

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

if vim.fn.has('macunix') == 0 then
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ["+"] = 'clip.exe',
            ["*"] = 'clip.exe',
        },
        paste = {
            ["+"] =
            'powershell.exe -nop -noni -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ["*"] =
            'powershell.exe -nop -noni -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
end
