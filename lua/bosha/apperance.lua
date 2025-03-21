local function set_background_based_on_appearance()
	-- Run the shell command to check macOS appearance
	-- command will return error if current theme is light
	-- if theme is dark it returns 'Dark'
	local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
	if not handle then
		vim.notify("Failed to execute shell command", vim.log.levels.ERROR)
		return
	end

	local appearance = handle:read("*a")
	if not appearance then
		vim.notify("Failed to read command output", vim.log.levels.ERROR)
		handle:close()
		return
	end

	handle:close()

	if appearance:match("Dark") then
		vim.o.background = "dark"
	else
		vim.o.background = "light"
	end
end

-- Check if we're running on macOS
if vim.fn.has("mac") == 1 then
	vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
		callback = set_background_based_on_appearance,
	})
end
