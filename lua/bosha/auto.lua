vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if not vim.g.neovide then
			vim.cmd(":cd %:p:h")
		end
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

if vim.fn.executable("kbdswitch") == 1 then
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			vim.api.nvim_command("silent !kbdswitch set com.apple.keylayout.ABC")
		end,
	})
end
