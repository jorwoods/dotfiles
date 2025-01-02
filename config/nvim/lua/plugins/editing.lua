return {
    -- Editing improvements
    { 'mbbill/undotree' },
    { 'numToStr/Comment.nvim' }, -- Quick comment keybdings


    -- Highlighting
    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },
    { "nvim-treesitter/nvim-treesitter-context", },

}
