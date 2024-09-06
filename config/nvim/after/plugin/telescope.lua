local builtin = require('telescope.builtin')
local telescopeConfig = require('telescope.config')
pcall(builtin.load_extension, 'fzf')

local telescope = require("telescope")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
	defaults = {
		-- `hidden = true` is not supported in text grep commands.
		vimgrep_arguments = vimgrep_arguments,
	},
	pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
	},
})

local function get_visual_selection()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  local n_lines = math.abs(cerow - csrow) + 1
  local lines = vim.api.nvim_buf_get_lines(0, csrow - 1, cerow, false)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], cscol, cecol)
  else
    lines[1] = string.sub(lines[1], cscol, string.len(lines[1]))
    lines[n_lines] = string.sub(lines[n_lines], 1, cecol)
  end
  return table.concat(lines, '\n')
end

vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '[P]roject [f]iles' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = '[P]roject git [f]iles' })
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > "), use_regex = true });
end, { desc = '[P]roject [s]earch' })
vim.keymap.set('v', '<leader>ps', function()
    builtin.grep_string({ search = get_visual_selection(), use_regex = false });
end, { desc = '[P]roject [s]earch' })
vim.keymap.set('n', '<leader>fs', builtin.current_buffer_fuzzy_find, { desc = 'Buffer [f]uzzy [s]earch' })
vim.keymap.set('n', '<leader>gc', builtin.git_branches, { desc = '[G]it [C]heckout' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = '[B]uffers' })
vim.keymap.set('i', '<c-r>', function ()
    builtin.registers()
end, { remap = true, silent = false, desc = "Paste from [r]egisters in insert mode" })
