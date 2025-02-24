return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local oil = require("oil")

		oil.setup({
			default_file_explorer = false,
			delete_to_trash = true,
			view_options = {
				show_hidden = true,
			},
		})

		vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", {})
		vim.keymap.set("n", "-", "<cmd>Oil<cr>", {})
	end,
}
