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

vim.g.mapleader = " "

nm(";", ":")

-- Double esc to stop highlighting search results
nm("<Esc><Esc>", "<CMD>nohlsearch<CR>")

-- NeoTree
-- nm("<leader>e", "<CMD>Neotree toggle<CR>")
-- nm("<leader>o", "<CMD>Neotree focus<CR>")
-- nm("<leader>e", "<CMD>lua MiniFiles.open()<cr>")
nm("<leader>e", "<CMD>Oil<CR>")
nm("-", "<cmd>Oil<cr>")

-- Buffer
-- nm("<TAB>", "<CMD>bnext<CR>")
-- nm("<S-TAB>", "<CMD>bprevious<CR>")
-- nm("<C-n>", "<CMD>bnext<CR>")
-- nm("<C-p>", "<CMD>bprevious<CR>")
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

-- Centered search results
-- nm("n", "nzz")
-- nm("N", "Nzz")
-- nm("*", "*zz")
-- nm("#", "#zz")
-- nm("g*", "g*zz")
-- nm("g#", "g#zz")

-- Don't skip wrapped lines
nm("j", "gj")
nm("k", "gk")

-- oo and OO to insert line below/above without going into insert mode
-- temporary commented out due to introducing big lag when I just o/O
-- nm("oo", "o<Esc>k")
-- nm("OO", "O<Esc>j")

-- Use ctrl-c / ctrl-v to copy/paste using global clipboard
-- vm('<C-C>', '<esc> "+yi')
im("<D-V>", '<esc>"+gPi')
vm("<D-C>", '<esc> "+yi')
-- im('<C-V>', '<cmd>set nowrap<cr><esc>"+gPi<esc><cmd>set wrap<cr>i')

nm("<M-z>", "<CMD>set wrap!<CR>")

-- Terminal keymaps
tm("<esc><esc>", "<c-\\><c-n>") -- double esc to enter normal mode from terminal input mode

-- Navigate windows easily when terminal is open in split window
tm("<C-h>", "<C-\\><C-N><C-w>h")
tm("<C-l>", "<C-\\><C-N><C-w>l")
tm("<C-k>", "<C-\\><C-N><C-w>k")
tm("<C-j>", "<C-\\><C-N><C-w>j")
