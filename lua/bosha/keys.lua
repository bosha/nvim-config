local map = vim.api.nvim_set_keymap

-- shortcut for a normal key bindinds
local function nm(key, command)
	map("n", key, command, { noremap = true })
end

-- shortcut for a input mode
local function im(key, command)
	map("i", key, command, { noremap = true })
end

-- shortcut for a visual mode
local function vm(key, command)
	map("v", key, command, { noremap = true })
end

-- shortcut for a terminal model
local function tm(key, command)
	map("t", key, command, { noremap = true })
end

-- Space as <leader>
vim.g.mapleader = " "

nm(";", ":")

-- Double esc to stop highlighting search results
nm("<Esc><Esc>", "<CMD>nohlsearch<CR>")

-- Buffer
nm("<C-n>", "<CMD>BufferNext<CR>")
nm("<C-p>", "<CMD>BufferPrevious<CR>")
-- <leader>b to list buffers and easily switch between them
-- <cmd> not used here intentionally: nvim forces to end the command with <CR> in this case,
-- but it's unnecessarry in this case
nm("<leader>b", ":ls<cr>:b<space>")

-- Window Navigation
nm("<C-h>", "<C-w>h")
nm("<C-l>", "<C-w>l")
nm("<C-k>", "<C-w>k")
nm("<C-j>", "<C-w>j")

-- Terminal
-- nm("<leader>th", "<CMD>ToggleTerm size=10 direction=horizontal<CR>")
-- nm("<leader>tv", "<CMD>ToggleTerm size=80 direction=vertical<CR>")

-- Don't skip wrapped lines
nm("j", "gj")
nm("k", "gk")

nm("<M-z>", "<CMD>set wrap!<CR>")

-- Terminal keymaps
tm("<esc><esc>", "<c-\\><c-n>") -- double esc to enter normal mode from terminal input mode

-- Navigate windows easily when terminal is open in split window
tm("<C-h>", "<C-\\><C-N><C-w>h")
tm("<C-l>", "<C-\\><C-N><C-w>l")
tm("<C-k>", "<C-\\><C-N><C-w>k")
tm("<C-j>", "<C-\\><C-N><C-w>j")
