vim.opt.linespace = 8 -- a little bit more space between lines
vim.g.neovide_remember_window_size = true -- remember previous window size on quit
vim.g.neovide_input_macos_option_key_is_meta = 'both' -- use opt key in keybinds

-- VimEnter does not work by some reason.
-- found solution here - https://github.com/neovide/neovide/issues/1477
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
	local current_workdir = vim.loop.cwd()
	--[[ 
	  reason for this condition is that I often open neovide from Alfred and 
	  neovide don't change the directory to the one that passed from Alfred.
	  It does open it in netrw and allow me to choose a file to edit, but :pwd
	  stays at root. So originally I was just executed a command :cd %:p:h to change
	  the dir and that's it. But 'FocusGained' triggered each time I switch apps/windows 
	  and pwd keeps changing all the time. 
	  The simpliest fix I can get in couple minutes is just check current working dir and
	  if it is root ('/'), then change it to the directory of opened file. Since I never 
	  place any code or config directly at root - it should be fine.
	--]]
	if current_workdir == "/" then
	  vim.cmd(":cd %:p:h")
	end
  end,
})


-- I set up globally to use C-c/C-v to use global buffer, probably I don't need this anymore
  -- -- vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  -- vim.keymap.set('v', '<D-c>', '"+y')    -- Copy
  -- -- vim.keymap.set('n', '<D-v>', '"+P')    -- Paste normal mode
  -- -- vim.keymap.set('v', '<D-v>', '"+P')    -- Paste visual mode
  -- vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  -- vim.keymap.set('i', '<D-v>', '<C-R>+') -- Paste insert mode
