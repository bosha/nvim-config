vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- if not vim.g.neovide then
		-- 	vim.cmd(":cd %:p:h")
		-- end
		vim.cmd(":cd %:p:h")
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
		-- disable spell check in terminal buffers
		vim.cmd("setlocal nospell")
	end,
})

-- Check if we're running on macOS
if vim.fn.has("mac") == 1 then
	vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
		callback = function()
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
		end,
	})
end

-- if vim.fn.executable("kbdswitch") == 1 then
-- 	vim.api.nvim_create_autocmd("InsertLeave", {
-- 		callback = function()
-- 			vim.api.nvim_command("silent !kbdswitch set com.apple.keylayout.ABC")
-- 		end,
-- 	})
-- end

-- local previous_layout = nil
-- local english_layout = "com.apple.keylayout.ABC"
--
-- if vim.fn.executable("kbdswitch") == 1 then
-- 	-- Store the current keyboard layout when leaving Insert Mode
-- 	print("kbdswitch found, layout autochange feature enabled")
-- 	vim.api.nvim_create_autocmd("InsertLeave", {
-- 		callback = function()
-- 			vim.system({ "kbdswitch", "get" }, { text = true }, function(result)
-- 				if result.code == 0 and result.stdout and result.stdout ~= "" then
-- 					local current_layout = result.stdout:gsub("\n", "") -- Trim newline
-- 					if current_layout == english_layout then
-- 						previous_layout = nil            -- No need to restore if it's already English
-- 					else
-- 						previous_layout = current_layout
-- 						vim.system({ "kbdswitch", "set", english_layout }) -- Switch to English
-- 					end
-- 				end
-- 			end)
-- 		end,
-- 	})
--
-- 	-- Restore the previous keyboard layout when entering Insert Mode
-- 	vim.api.nvim_create_autocmd("InsertEnter", {
-- 		callback = function()
-- 			if previous_layout then
-- 				vim.system({ "kbdswitch", "set", previous_layout })
-- 			end
-- 		end,
-- 	})
-- end

--------

-- -- Define a variable to store the previous keyboard layout for each buffer
-- local buffer_layouts = {}
--
-- -- Function to execute kbdswitch commands asynchronously
-- local function kbdswitch_command(command, callback)
-- 	vim.fn.jobstart(command, {
-- 		stdout_buffered = true,
-- 		on_stdout = function(_, data)
-- 			if callback then
-- 				callback(table.concat(data, ""))
-- 			end
-- 		end,
-- 	})
-- end
--
-- -- Function to get the current keyboard layout
-- local function get_current_layout(callback)
-- 	kbdswitch_command({ "kbdswitch", "get" }, callback)
-- end
--
-- -- Function to set the keyboard layout
-- local function set_layout(layout)
-- 	kbdswitch_command({ "kbdswitch", "set", layout })
-- end
--
-- -- Function to handle leaving insert mode
-- local function on_insert_leave()
-- 	get_current_layout(function(layout)
-- 		-- Save the current layout for the buffer
-- 		local buf = vim.api.nvim_get_current_buf()
-- 		buffer_layouts[buf] = layout
--
-- 		-- Switch to English layout
-- 		set_layout("com.apple.keylayout.ABC")
-- 	end)
-- end
--
-- -- Function to handle entering insert mode
-- local function on_insert_enter()
-- 	local buf = vim.api.nvim_get_current_buf()
-- 	local prev_layout = buffer_layouts[buf]
--
-- 	if prev_layout and prev_layout ~= "com.apple.keylayout.ABC" then
-- 		-- Restore the previous layout if it wasn't English
-- 		set_layout(prev_layout)
-- 	end
-- end
--
-- -- Start the kbdswitch daemon
-- kbdswitch_command({ "kbdswitch", "daemon" })
--
-- -- Set up autocommands to handle insert mode changes
-- vim.api.nvim_create_autocmd("InsertLeave", {
-- 	callback = on_insert_leave,
-- })
--
-- vim.api.nvim_create_autocmd("InsertEnter", {
-- 	callback = on_insert_enter,
-- })

-----------------------------------------

-- Configuration
local default_layout = "com.apple.keylayout.ABC" -- Default layout to switch to
local autoswitching_enabled = false              -- Whether autoswitching is enabled
local save_restore_layout = true                 -- Whether to save and restore layouts
local buffer_layouts = {}                        -- Stores previous layouts for each buffer
local autocommand_ids = {}                       -- Stores IDs of autocommands we register

-- Function to check if kbdswitch exists
local function kbdswitch_exists()
	return vim.fn.executable("kbdswitch") == 1
end

-- Function to execute kbdswitch commands asynchronously
local function kbdswitch_command(command, callback)
	vim.fn.jobstart(command, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if callback then
				callback(table.concat(data, ""))
			end
		end,
	})
end

-- Function to get the current keyboard layout
local function get_current_layout(callback)
	kbdswitch_command({ "kbdswitch", "get" }, callback)
end

-- Function to set the keyboard layout
local function set_layout(layout)
	kbdswitch_command({ "kbdswitch", "set", layout })
end

-- Function to handle leaving insert mode
local function on_insert_leave()
	get_current_layout(function(layout)
		-- Save the current layout for the buffer if save_restore_layout is enabled
		if save_restore_layout then
			local buf = vim.api.nvim_get_current_buf()
			buffer_layouts[buf] = layout
		end

		-- Switch to the default layout
		set_layout(default_layout)
	end)
end

-- Function to handle entering insert mode
local function on_insert_enter()
	if save_restore_layout then
		local buf = vim.api.nvim_get_current_buf()
		local prev_layout = buffer_layouts[buf]

		if prev_layout and prev_layout ~= default_layout then
			-- Restore the previous layout if it wasn't the default
			set_layout(prev_layout)
		end
	end
end

-- Function to register autocommands for autoswitching
local function register_autocommands()
	-- Register InsertLeave autocommand and store its ID
	autocommand_ids.InsertLeave = vim.api.nvim_create_autocmd("InsertLeave", {
		callback = on_insert_leave,
	})

	-- Register InsertEnter autocommand and store its ID
	autocommand_ids.InsertEnter = vim.api.nvim_create_autocmd("InsertEnter", {
		callback = on_insert_enter,
	})
end

-- Function to unregister autocommands for autoswitching
local function unregister_autocommands()
	if autocommand_ids.InsertLeave then
		vim.api.nvim_del_autocmd(autocommand_ids.InsertLeave)
		autocommand_ids.InsertLeave = nil
	end
	if autocommand_ids.InsertEnter then
		vim.api.nvim_del_autocmd(autocommand_ids.InsertEnter)
		autocommand_ids.InsertEnter = nil
	end
end

-- Function to enable autoswitching
local function enable_autoswitching()
	if not autoswitching_enabled then
		autoswitching_enabled = true
		register_autocommands()
		vim.api.nvim_echo({ { "Autoswitching enabled.", "MoreMsg" } }, true, {})
	end
end

-- Function to disable autoswitching
local function disable_autoswitching()
	if autoswitching_enabled then
		autoswitching_enabled = false
		unregister_autocommands()
		vim.api.nvim_echo({ { "Autoswitching disabled.", "WarningMsg" } }, true, {})
	end
end

-- Function to toggle autoswitching
local function toggle_autoswitching()
	if autoswitching_enabled then
		disable_autoswitching()
	else
		enable_autoswitching()
	end
end

-- Function to toggle save/restore layout behavior
local function toggle_save_restore_layout()
	save_restore_layout = not save_restore_layout
	local status = save_restore_layout and "enabled" or "disabled"
	vim.api.nvim_echo({ { "Save/restore layout " .. status .. ".", "MoreMsg" } }, true, {})
end

-- Check if kbdswitch exists
if kbdswitch_exists() then
	-- Print a confirmation message
	vim.api.nvim_echo({ { "kbdswitch found. Keyboard layout switching enabled.", "MoreMsg" } }, true, {})

	-- Start the kbdswitch daemon
	kbdswitch_command({ "kbdswitch", "daemon" })

	-- Register autocommands if autoswitching is enabled
	if autoswitching_enabled then
		register_autocommands()
	end

	-- Add commands to enable, disable, or toggle autoswitching
	vim.api.nvim_create_user_command("EnableAutoswitching", enable_autoswitching, {})
	vim.api.nvim_create_user_command("DisableAutoswitching", disable_autoswitching, {})
	vim.api.nvim_create_user_command("ToggleAutoswitching", toggle_autoswitching, {})

	-- Add command to toggle save/restore layout behavior
	vim.api.nvim_create_user_command("ToggleSaveRestoreLayout", toggle_save_restore_layout, {})
else
	-- Print a warning message if kbdswitch is not found
	vim.api.nvim_echo({ { "kbdswitch not found. Keyboard layout switching disabled.", "WarningMsg" } }, true, {})
end
