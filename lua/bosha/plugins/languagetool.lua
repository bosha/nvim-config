return {
	"vigoux/LanguageTool.nvim",
	-- does not work, disabling until I found way how to make it work
	enabled = false,
	config = function()
		vim.g.languagetool_server_command = "echo LanguageTool server started"
	end,
}
