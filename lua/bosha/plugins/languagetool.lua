return {
  "vigoux/LanguageTool.nvim",
  enabled = false,
  config = function()
	vim.g.languagetool_server_command = "echo LanguageTool server started"
  end,
}
