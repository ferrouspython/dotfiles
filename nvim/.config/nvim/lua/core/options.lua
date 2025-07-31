vim.g.have_nerd_font = true -- Turns on nerd fonts
vim.opt.number = true -- Turns on line numbers
vim.opt.relativenumber = true -- Turns on relative line numbers
vim.opt.mouse = "" -- Disable mouse mode
vim.opt.showmode = false -- Turns off the mode
vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching unless \C or capital in search
vim.opt.smartcase = true -- Turn on smart case
vim.opt.signcolumn = "yes" -- Keep sign on by default
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time
vim.opt.splitright = true -- Force all vertical splits to go to the right of the current window
vim.opt.splitbelow = true -- Force all horizontal splits to go below current window
vim.opt.inccommand = "split" -- Preview live substitutions
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 5 -- Minimal number of lines to keep above and below the cursor
vim.opt.numberwidth = 2 -- Set number column width to 2
vim.opt.shiftwidth = 2 -- The number of spaces inserted for each indentation
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.softtabstop = 2 -- Number of spaces that a tab counts for while performing editing operations
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Make indenting smart again
vim.opt.swapfile = false -- Creates a swapfile
vim.opt.showtabline = 2 -- Always show tabs
vim.opt.fileencoding = 'utf-8' -- Set encoding
vim.opt.autoindent = true -- Copy indent from current line when starting a new one
vim.opt.pumheight = 10 -- Popup menu height

-- Terminal colorscheme configuration
vim.opt.termguicolors = false -- Use terminal colors instead of GUI colors
vim.opt.background = "dark" -- Set to "light" if using a light terminal theme
vim.cmd('colorscheme default') -- Use default colorscheme that respects terminal colors
