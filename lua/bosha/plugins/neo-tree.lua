return {
	"nvim-neo-tree/neo-tree.nvim",
	enabled= false,
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function() 
		-- vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle filesystem reveal left<cr>", {})
	end,
}
