vim.opt.linespace = 8 -- a little bit more space between lines
vim.g.neovide_remember_window_size = true -- remember previous window size on quit
vim.g.neovide_input_macos_option_key_is_meta = 'both' -- use opt key in keybinds

local home_bin = vim.fn.expand("~/bin")
if vim.fn.isdirectory(home_bin) == 1 then
	vim.env.PATH = vim.env.PATH .. ":" .. home_bin
end

-- VimEnter does not work by some reason.
-- found solution here - https://github.com/neovide/neovide/issues/1477
vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
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
		local current_workdir = vim.loop.cwd()
		if current_workdir == "/" then
			vim.cmd(":cd %:p:h")
		end
	end,
})
