require 'core.options'
require 'core.keymaps'
require 'core.snippets'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
local lazyrepo = "https://github.com/folke/lazy.nvim.git"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'--branch=stable',
		lazyrepo,
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	spec = {
		{ import = "plugins"},
	},
})
