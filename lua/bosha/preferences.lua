local opt = vim.opt

-- -- disabling to finally learn how to use vim registers
-- opt.clipboard = "unnamedplus"

-- set my spelling languages for spellcheck
opt.spelllang = { "ru", "en" }

-- [[ general configuration (aka I can't come up with category for it) ]]
opt.ignorecase = true
opt.smartcase = true
opt.showmatch = true
opt.incsearch = true
opt.hlsearch = true -- enable search highlighting

opt.ch = 2 -- command line two lines wide
vim.api.nvim_set_option_value("cpoptions", "cesB$", {})
opt.list = true -- show 'invisibles'
opt.scrolloff = 10
opt.cursorline = true -- hightlight the line with the cursor
opt.ruler = true -- show cursor all the time
opt.showcmd = true -- show uncomplete commands in the status bar
opt.showmode = true -- show current mode in the status line
-- opt.virtualedit = 'all' -- temporary disabled due to issues with nvim-markdown
opt.showmatch = true -- show matching brackets
opt.matchtime = 5 -- how long matching brackets to blink
opt.number = true -- enable line numbering
opt.relativenumber = true -- enable relivate line numbers
opt.mouse = "a" -- enable mouse support (primary using for scroll sometimes)
opt.wildmenu = true -- When 'wildmenu' is on, command-line completion operates in an enhanced mode.
opt.filetype = "on"

-- [[ color theme ]]
opt.background = "dark"
opt.termguicolors = true

opt.syntax = 'on'

-- [[ Tab behavior configuration ]]
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smarttab = true
opt.smartindent = true

-- [[ Split configuration ]]
opt.splitright = true -- vertical splits are always on right
opt.splitbelow = true -- horizontal splits are always below

-- Do not comment new line after comment
vim.cmd([[autocmd BufEnter * set fo-=c fo-=r fo-=o]])

-- Configuring the directories for undo, backup and swap files
vim.fn.mkdir(vim.fn.stdpath("data") .. "/backup", "p")
vim.fn.mkdir(vim.fn.stdpath("data") .. "/undo", "p")
vim.fn.mkdir(vim.fn.stdpath("data") .. "/swap", "p")

opt.backupdir = vim.fn.stdpath("data") .. "/backup//"
opt.directory= vim.fn.stdpath("data") .. "/swap//"
opt.undodir= vim.fn.stdpath("data") .. "/undo//"

opt.swapfile = true
opt.backup = true
opt.undofile = true

-- backspace configuration
opt.backspace = "indent,eol,start"
