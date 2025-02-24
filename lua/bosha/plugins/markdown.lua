return {
	{
		"iamcco/markdown-preview.nvim",
		config = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"ixru/nvim-markdown",
	},
	{
		"dhruvasagar/vim-table-mode",
		enabled = false,
		config = function()
			vim.g.table_mode_syntax = 0
		end,
	},
}
