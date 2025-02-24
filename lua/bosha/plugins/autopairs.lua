return {
	"windwp/nvim-autopairs",
	enabled = false,
	config = function()
		local autopairs = require("nvim-autopairs")
		autopairs.setup({
			disable_filetype = { "TelescopePrompt", "vim" },
		})
	end,
}
