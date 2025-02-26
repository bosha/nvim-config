return {
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.cmd([[do FileType]])
			vim.cmd([[
				function OpenMarkdownPreview(url)
					let cmd = "open -n -a 'Vivaldi' " . shellescape(a:url)
					silent call system(cmd)
				endfunction
			]])
			vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
			vim.g.mkdp_auto_close = 0
			vim.g.mkdp_preview_options = {
				disable_sync_scroll = 1,
			}
		end,
	},
	{
		"ixru/nvim-markdown",
	},
	{
		"dhruvasagar/vim-table-mode",
		-- does not work properly, disabling until I fix it
		enabled = false,
		config = function()
			vim.g.table_mode_syntax = 0
		end,
	},
}
