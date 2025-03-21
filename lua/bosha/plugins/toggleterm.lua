return {
	{
		"akinsho/toggleterm.nvim",
		config = function()
			local toggleterm = require("toggleterm")

			toggleterm.setup({
				size = 10,
				open_mapping = [[<c-\>]],
				shading_factor = 2,
				direction = "float",
				float_opts = {
					border = "curved",
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
			})
		end,
	}
}
