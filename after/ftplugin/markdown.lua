vim.opt.number = true -- enable line numbering
vim.opt.relativenumber = true -- enable relivate line numbers

vim.opt.spell = true
-- vim.opt.spelllang = { "ru", "en" }

-- local opt= vim.opt_local
-- local map = vim.api.nvim_set_keymap

local function map(mode, key, command)
	vim.api.nvim_set_keymap(mode, key, command, { noremap = true })
end

-- Markdown Preview
map("n", "<leader>m", "<CMD>MarkdownPreviewToggle<CR>")

local set_heading_level = function(line, level)
	return string.rep("#", level) .. " " .. line
end

local remove_heading = function(line)
	local new_str, _ = string.gsub(line, "^#+( ?)", "")
	return new_str
end

-- local change_heading_level_to = function(line, level)
--   return set_heading_level(remove_heading(line), level)
-- end

local toggle_heading_level = function(line, level)
	local string_heading_level = nil

	if string.match(line, "^#+( ?)") then
		_, string_heading_level = string.find(line, "^#+")
		line = remove_heading(line)
	end

	if string_heading_level == level then
		return line
	end

	return set_heading_level(line, level)
end

local nvim_toggle_heading_level = function(level)
	return function()
		local current_line = vim.api.nvim_get_current_line()
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local new_line = toggle_heading_level(current_line, level)

		vim.api.nvim_buf_set_lines(0, row - 1, row, true, { new_line })
	end
end

vim.keymap.set({ "i", "n", "v" }, "<M-t>", nvim_toggle_heading_level(1))
vim.keymap.set({ "i", "n", "v" }, "<M-h>", nvim_toggle_heading_level(2))
vim.keymap.set({ "i", "n", "v" }, "<M-j>", nvim_toggle_heading_level(3))

-- https://www.reddit.com/r/neovim/comments/x7xztz/how_can_i_get_lines_where_the_cursor_is_neovim/

-- -- Configuration
-- local config = {
--   show_hashtags = false, -- Default behavior: hide hashtags
-- }
--
-- -- Function to collect markdown headings
-- local function collect_markdown_headings()
--   local headings = {}
--   local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
--   local min_level = nil
--
--   -- Find the minimum heading level in the file
--   for _, line in ipairs(lines) do
-- 	local level = line:match("^(#+)%s+")
-- 	if level then
-- 	  level = #level
-- 	  if min_level == nil or level < min_level then
-- 		min_level = level
-- 	  end
-- 	end
--   end
--
--   -- Collect headings and adjust levels based on the minimum level
--   for i, line in ipairs(lines) do
-- 	local level = line:match("^(#+)%s+")
-- 	if level then
-- 	  level = #level
-- 	  local adjusted_level = level - (min_level - 1) -- Normalize levels starting from 1
-- 	  table.insert(headings, {
-- 		level = adjusted_level,
-- 		text = line:gsub("^#+%s+", ""),
-- 		raw_text = line, -- Keep the original line with hashtags
-- 		line = i
-- 	  })
-- 	end
--   end
--
--   return headings
-- end
--
-- -- Function to display headings as a tree in a floating window
-- local function display_headings_tree(headings)
--   local width = math.floor(vim.o.columns * 0.9)
--   local height = math.floor(vim.o.lines * 0.8)
--   local row = math.floor((vim.o.lines - height) / 2)
--   local col = math.floor((vim.o.columns - width) / 2)
--
--   -- Create a new buffer
--   local buf = vim.api.nvim_create_buf(false, true)
--   local win = vim.api.nvim_open_win(buf, true, {
-- 	relative = 'editor',
-- 	width = width,
-- 	height = height,
-- 	row = row,
-- 	col = col,
-- 	style = 'minimal',
-- 	border = 'rounded'
--   })
--
--   -- Function to refresh the tree content based on the current config
--   local function refresh_tree()
-- 	-- Make the buffer modifiable temporarily
-- 	vim.api.nvim_buf_set_option(buf, 'modifiable', true)
--
-- 	local tree_lines = {}
-- 	for _, heading in ipairs(headings) do
-- 	  local indent = string.rep("  ", heading.level - 1)
-- 	  local line = indent .. (config.show_hashtags and heading.raw_text or heading.text)
-- 	  table.insert(tree_lines, line)
-- 	end
--
-- 	-- Set the buffer content
-- 	vim.api.nvim_buf_set_lines(buf, 0, -1, false, tree_lines)
--
-- 	-- Highlight headings with colorscheme colors
-- 	local colors = {
-- 	  h1 = vim.api.nvim_get_hl_by_name("markdownH1", true),
-- 	  h2 = vim.api.nvim_get_hl_by_name("markdownH2", true),
-- 	  h3 = vim.api.nvim_get_hl_by_name("markdownH3", true),
-- 	  h4 = vim.api.nvim_get_hl_by_name("markdownH4", true),
-- 	  h5 = vim.api.nvim_get_hl_by_name("markdownH5", true),
-- 	  h6 = vim.api.nvim_get_hl_by_name("markdownH6", true),
-- 	}
--
-- 	for i, heading in ipairs(headings) do
-- 	  local hl_group = "markdownH" .. heading.level
-- 	  if colors["h" .. heading.level] then
-- 		vim.api.nvim_buf_add_highlight(buf, -1, hl_group, i - 1, 0, -1)
-- 	  end
-- 	end
--
-- 	-- Make the buffer non-modifiable again
-- 	vim.api.nvim_buf_set_option(buf, 'modifiable', false)
--   end
--
--   -- Initial tree refresh
--   refresh_tree()
--
--   -- Set some buffer options
--   vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
--
--   -- Keymap to toggle hashtags
--   vim.api.nvim_buf_set_keymap(buf, 'n', 't', '', {
-- 	noremap = true,
-- 	silent = true,
-- 	callback = function()
-- 	  config.show_hashtags = not config.show_hashtags
-- 	  refresh_tree()
-- 	end
--   })
--
--   -- Keymap to close the window and jump to the heading
--   vim.api.nvim_buf_set_keymap(buf, 'n', '<Enter>', '<cmd>lua vim.api.nvim_win_close(' .. win .. ', true)<CR>', {noremap = true, silent = true})
--   vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
--   vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<CR>', {noremap = true, silent = true})
--
--   -- Highlight the current line
--   vim.api.nvim_win_set_option(win, 'cursorline', true)
--
--   -- Function to jump to the selected heading
--   local function jump_to_heading()
-- 	local cursor_pos = vim.api.nvim_win_get_cursor(win)
-- 	local selected_line = cursor_pos[1]
-- 	local heading = headings[selected_line]
--
-- 	if heading then
-- 	  -- Close the floating window
-- 	  vim.api.nvim_win_close(win, true)
--
-- 	  -- Jump to the heading line in the main buffer
-- 	  vim.api.nvim_win_set_cursor(0, {heading.line, 0})
-- 	end
--   end
--
--   -- Map <Enter> to jump to the heading
--   vim.api.nvim_buf_set_keymap(buf, 'n', '<Enter>', '', {
-- 	noremap = true,
-- 	silent = true,
-- 	callback = jump_to_heading
--   })
-- end
--
-- -- Main function to collect and display headings
-- local function show_markdown_headings_tree()
--   local headings = collect_markdown_headings()
--   display_headings_tree(headings)
-- end
--
-- -- Command to trigger the function
-- vim.api.nvim_create_user_command("MDHeadings", show_markdown_headings_tree, {})

-- Configuration
local config = {
	show_hashtags = false, -- Default behavior: hide hashtags
	skip_h1 = true, -- Set to false to include H1 headings
}

-- Track the floating window and buffer
local floating_win = nil
local floating_buf = nil

-- Function to collect markdown headings
local function collect_markdown_headings()
	local headings = {}
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local min_level = nil

	-- Find the minimum heading level in the file
	for _, line in ipairs(lines) do
		local level = line:match("^(#+)%s+")
		if level then
			level = #level
			if min_level == nil or level < min_level then
				min_level = level
			end
		end
	end

	-- Collect headings and adjust levels based on the minimum level
	for i, line in ipairs(lines) do
		local level = line:match("^(#+)%s+")
		if level then
			level = #level
			local adjusted_level = level - (min_level - 1) -- Normalize levels starting from 1
			table.insert(headings, {
				level = adjusted_level,
				text = line:gsub("^#+%s+", ""),
				raw_text = line, -- Keep the original line with hashtags
				line = i,
			})
		end
	end

	return headings
end

-- Function to display headings as a tree in a floating window
local function display_headings_tree(headings)
	local width = math.floor(vim.o.columns * 0.8) -- 80% of the main window width
	local height = math.floor(vim.o.lines * 0.6) -- 60% of the main window height
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- Reuse existing window and buffer if they exist
	if floating_win and vim.api.nvim_win_is_valid(floating_win) then
		vim.api.nvim_set_current_win(floating_win)
		return
	end

	-- Create a new buffer
	floating_buf = floating_buf or vim.api.nvim_create_buf(false, true)
	floating_win = vim.api.nvim_open_win(floating_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	-- Function to refresh the tree content based on the current config
	local function refresh_tree()
		-- Make the buffer modifiable temporarily
		vim.api.nvim_buf_set_option(floating_buf, "modifiable", true)

		local tree_lines = {}
		for _, heading in ipairs(headings) do
			local indent = string.rep("  ", heading.level - 1)
			local line = indent .. (config.show_hashtags and heading.raw_text or heading.text)
			table.insert(tree_lines, line)
		end

		-- Set the buffer content
		vim.api.nvim_buf_set_lines(floating_buf, 0, -1, false, tree_lines)

		-- Highlight headings with colorscheme colors
		-- local colors = {
		-- 	h1 = vim.api.nvim_get_hl_by_name("markdownH1", true),
		-- 	h2 = vim.api.nvim_get_hl_by_name("markdownH2", true),
		-- 	h3 = vim.api.nvim_get_hl_by_name("markdownH3", true),
		-- 	h4 = vim.api.nvim_get_hl_by_name("markdownH4", true),
		-- 	h5 = vim.api.nvim_get_hl_by_name("markdownH5", true),
		-- 	h6 = vim.api.nvim_get_hl_by_name("markdownH6", true),
		-- }
		--
		-- for i, heading in ipairs(headings) do
		-- 	local hl_group = "markdownH" .. heading.level
		-- 	if colors["h" .. heading.level] then
		-- 		vim.api.nvim_buf_add_highlight(floating_buf, -1, hl_group, i - 1, 0, -1)
		-- 	end
		-- end

		-- Make the buffer non-modifiable again
		vim.api.nvim_buf_set_option(floating_buf, "modifiable", false)
	end

	-- Initial tree refresh
	refresh_tree()

	-- Set some buffer options
	vim.api.nvim_buf_set_option(floating_buf, "filetype", "markdown")

	-- Keymap to toggle hashtags
	vim.api.nvim_buf_set_keymap(floating_buf, "n", "t", "", {
		noremap = true,
		silent = true,
		callback = function()
			config.show_hashtags = not config.show_hashtags
			refresh_tree()
		end,
	})

	-- Keymap to close the window
	vim.api.nvim_buf_set_keymap(
		floating_buf,
		"n",
		"q",
		"<cmd>lua vim.api.nvim_win_close(" .. floating_win .. ", true)<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		floating_buf,
		"n",
		"<Esc>",
		"<cmd>lua vim.api.nvim_win_close(" .. floating_win .. ", true)<CR>",
		{ noremap = true, silent = true }
	)

	-- Keymap to jump to the selected heading
	vim.api.nvim_buf_set_keymap(floating_buf, "n", "<Enter>", "", {
		noremap = true,
		silent = true,
		callback = function()
			local cursor_pos = vim.api.nvim_win_get_cursor(floating_win)
			local selected_line = cursor_pos[1]
			local heading = headings[selected_line]

			if heading then
				-- Close the floating window
				vim.api.nvim_win_close(floating_win, true)
				floating_win = nil

				-- Jump to the heading line in the main buffer
				vim.api.nvim_win_set_cursor(0, { heading.line, 0 })
			end
		end,
	})

	-- Highlight the current line
	vim.api.nvim_win_set_option(floating_win, "cursorline", true)

	-- Find the closest heading above the current cursor position
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local closest_heading = nil

	-- Iterate upwards from the current line to find the closest heading
	for i = current_line, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
		local level = line:match("^(#+)%s+")
		if level then
			closest_heading = {
				level = #level,
				text = line:gsub("^#+%s+", ""),
				raw_text = line,
				line = i,
			}
			break
		end
	end

	-- Move the cursor in the floating window to the closest heading
	if closest_heading then
		for i, heading in ipairs(headings) do
			if heading.line == closest_heading.line then
				vim.api.nvim_win_set_cursor(floating_win, { i, 0 })
				break
			end
		end
	end
end

-- Function to open headings in Telescope
local function open_headings_in_telescope()
	local headings = collect_markdown_headings()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local opts = {
		prompt_title = "Markdown Headings",
		finder = finders.new_table({
			results = headings,
			entry_maker = function(entry)
				return {
					value = entry,
					display = string.rep("  ", entry.level - 1) .. entry.text,
					ordinal = entry.text,
				}
			end,
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				vim.api.nvim_win_set_cursor(0, { selection.value.line, 0 })
			end)
			return true
		end,
	}

	pickers.new(opts, {}):find()
end

-- Main function to collect and display headings
local function show_markdown_headings_tree()
	local headings = collect_markdown_headings()
	display_headings_tree(headings)
end

-- Command to trigger the function
vim.api.nvim_create_user_command("MDHeadings", show_markdown_headings_tree, {})
vim.api.nvim_create_user_command("MDHeadingsTelescope", open_headings_in_telescope, {})

vim.keymap.set("n", "<leader>t", "<cmd>MDHeadings<cr>")
vim.keymap.set("n", "<leader>f", "<cmd>MDHeadingsTelescope<cr>")

-- ----------------------------------------------------------------
-- Helper function to check if the word is already wrapped with the given markers
local function is_wrapped(word, start_marker, end_marker)
	return word:sub(1, #start_marker) == start_marker and word:sub(- #end_marker) == end_marker
end

-- Helper function to wrap or unwrap a word with the given markers
local function toggle_wrap(word, start_marker, end_marker)
	if is_wrapped(word, start_marker, end_marker) then
		-- Remove markers
		return word:sub(#start_marker + 1, - #end_marker - 1)
	else
		-- Add markers
		return start_marker .. word .. end_marker
	end
end

-- Toggle bold in Normal mode
_G.toggle_bold = function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local word = vim.fn.expand("<cword>")

	-- Toggle the word with double asterisks
	local new_word = toggle_wrap(word, "**", "**")

	-- Replace the word in the line
	local new_line = line:gsub("%f[%w]" .. vim.fn.escape(word, "%") .. "%f[%W]", new_word, 1)
	vim.api.nvim_set_current_line(new_line)

	-- Move the cursor to the middle of the word
	local new_col = col + (#new_word - #word)
	vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), new_col })
end

-- Toggle italic in Normal mode
_G.toggle_italic = function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local word = vim.fn.expand("<cword>")

	-- Toggle the word with underscores
	local new_word = toggle_wrap(word, "__", "__")

	-- Replace the word in the line
	local new_line = line:gsub("%f[%w]" .. vim.fn.escape(word, "%") .. "%f[%W]", new_word, 1)
	vim.api.nvim_set_current_line(new_line)

	-- Move the cursor to the middle of the word
	local new_col = col + (#new_word - #word)
	vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), new_col })
end

-- Toggle inline code in Normal mode
_G.toggle_inline_code = function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local word = vim.fn.expand("<cword>")

	-- Toggle the word with backticks
	local new_word = toggle_wrap(word, "`", "`")

	-- Replace the word in the line
	local new_line = line:gsub("%f[%w]" .. vim.fn.escape(word, "%") .. "%f[%W]", new_word, 1)
	vim.api.nvim_set_current_line(new_line)

	-- Move the cursor to the middle of the word
	local new_col = col + (#new_word - #word)
	vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), new_col })
end

-- Toggle bold in Visual mode
_G.toggle_bold_visual = function()
	local start_line, start_col = vim.fn.getpos("'<")[2], vim.fn.getpos("'<")[3] - 1
	local end_line, end_col = vim.fn.getpos("'>")[2], vim.fn.getpos("'>")[3] - 1
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	-- Get the selected text
	local selected_text = lines[1]:sub(start_col + 1, end_col)

	-- Toggle the selected text with double asterisks
	local new_text = toggle_wrap(selected_text, "**", "**")

	-- Replace the selected text in the line
	lines[1] = lines[1]:sub(1, start_col) .. new_text .. lines[1]:sub(end_col + 1)
	vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)

	-- Move the cursor to the end of the selection
	vim.api.nvim_win_set_cursor(0, { start_line, start_col + #new_text })
end

-- Toggle italic in Visual mode
_G.toggle_italic_visual = function()
	local start_line, start_col = vim.fn.getpos("'<")[2], vim.fn.getpos("'<")[3] - 1
	local end_line, end_col = vim.fn.getpos("'>")[2], vim.fn.getpos("'>")[3] - 1
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	-- Get the selected text
	local selected_text = lines[1]:sub(start_col + 1, end_col)

	-- Toggle the selected text with underscores
	local new_text = toggle_wrap(selected_text, "__", "__")

	-- Replace the selected text in the line
	lines[1] = lines[1]:sub(1, start_col) .. new_text .. lines[1]:sub(end_col + 1)
	vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)

	-- Move the cursor to the end of the selection
	vim.api.nvim_win_set_cursor(0, { start_line, start_col + #new_text })
end

-- Toggle inline code in Visual mode
_G.toggle_inline_code_visual = function()
	local start_line, start_col = vim.fn.getpos("'<")[2], vim.fn.getpos("'<")[3] - 1
	local end_line, end_col = vim.fn.getpos("'>")[2], vim.fn.getpos("'>")[3] - 1
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	-- Get the selected text
	local selected_text = lines[1]:sub(start_col + 1, end_col)

	-- Toggle the selected text with backticks
	local new_text = toggle_wrap(selected_text, "`", "`")

	-- Replace the selected text in the line
	lines[1] = lines[1]:sub(1, start_col) .. new_text .. lines[1]:sub(end_col + 1)
	vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)

	-- Move the cursor to the end of the selection
	vim.api.nvim_win_set_cursor(0, { start_line, start_col + #new_text })
end

-- Key mappings for Normal mode
vim.api.nvim_set_keymap("n", "<A-b>", ":lua toggle_bold()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-i>", ":lua toggle_italic()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-c>", ":lua toggle_inline_code()<CR>", { noremap = true, silent = true })

-- Key mappings for Visual mode
vim.api.nvim_set_keymap("v", "<A-b>", ":lua toggle_bold_visual()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-i>", ":lua toggle_italic_visual()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-c>", ":lua toggle_inline_code_visual()<CR>", { noremap = true, silent = true })

-- winbar

-- Function to get the nested headings hierarchy
local function get_nested_headings()
	local line_num = vim.fn.line(".") -- Get current line number
	local headings = {}
	local current_level = nil -- Track the level of the current heading

	-- Search upwards for headings above the cursor
	for i = line_num, 1, -1 do
		local line = vim.fn.getline(i)
		local level = line:match("^(#+) .+") -- Match the heading level (e.g., #, ##)
		if level then
			level = #level -- Convert to number (e.g., # -> 1, ## -> 2)

			-- If this is the first heading found, set it as the current heading
			if not current_level then
				current_level = level
				table.insert(headings, { level = level, text = line })
			else
				-- Only include headings higher in the hierarchy (lower level number)
				if level < current_level then
					table.insert(headings, { level = level, text = line })
					current_level = level -- Update the current level
				end
			end
		end
	end

	-- Reverse the headings to show them in top-down order
	local reversed_headings = {}
	for i = #headings, 1, -1 do
		table.insert(reversed_headings, headings[i].text)
	end

	-- Skip H1 if configured
	if config.skip_h1 and #reversed_headings > 0 and reversed_headings[1]:match("^# ") then
		table.remove(reversed_headings, 1)
	end

	return reversed_headings
end

-- Function to truncate the headings to fit the window width
local function truncate_headings(headings, max_width)
	local result = table.concat(headings, " > ")
	if #result <= max_width then
		return result
	end

	-- Truncate from the beginning until the current heading fits
	local current_heading = headings[#headings]
	local remaining_width = max_width - #current_heading - 3 -- Account for " > " separator
	if remaining_width <= 0 then
		return current_heading -- Only show the current heading if no space is left
	end

	-- Build the truncated string
	local truncated = ""
	for i = #headings - 1, 1, -1 do
		local part = headings[i] .. " > "
		if #truncated + #part <= remaining_width then
			truncated = part .. truncated
		else
			break
		end
	end

	return truncated .. current_heading
end

-- Function to update the winbar with the nested headings
local function update_winbar()
	local headings = get_nested_headings()
	if #headings == 0 then
		vim.wo.winbar = ""
		return
	end

	-- Get the available width for the winbar
	local win_width = vim.api.nvim_win_get_width(0)
	local max_width = win_width - 10 -- Reserve some space for padding

	-- Truncate the headings to fit the window width
	local truncated_headings = truncate_headings(headings, max_width)

	-- Set the winbar
	vim.wo.winbar = "󰋼 " .. truncated_headings
end

-- Set up autocommands to update the winbar on cursor movement and window resize
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinResized" }, {
	pattern = "*.md",
	callback = update_winbar,
})

-- -- Initialize the winbar when opening a Markdown file
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   pattern = "*.md",
--   callback = update_winbar,
-- })

-- ----------------------------------------------------------------------------
-- Function to find the next heading of a specific level
local function find_next_heading(level)
	local current_line = vim.fn.line(".") -- Get current line number
	local pattern = "^" .. string.rep("#", level) .. " " -- Pattern for the heading (e.g., "## " for H2)

	-- Search for the next heading of the specified level
	local next_line = vim.fn.search(pattern, "W") -- "W" means wrap around the end of the file
	if next_line > 0 then
		vim.api.nvim_win_set_cursor(0, { next_line, 0 }) -- Move cursor to the heading
	else
		vim.api.nvim_echo({ { "No more H" .. level .. " headings found.", "WarningMsg" } }, false, {})
	end
end

-- Function to check if a heading of a specific level exists
local function heading_exists(level)
	local pattern = "^" .. string.rep("#", level) .. " " -- Pattern for the heading
	return vim.fn.search(pattern, "nw") > 0 -- "nw" means no move and wrap
end

-- Set up keybindings for <Leader>1 to <Leader>6
for level = 1, 6 do
	vim.keymap.set("n", "<Leader>" .. level, function()
		if not heading_exists(level) then
			vim.api.nvim_echo({ { "No H" .. level .. " headings found in the document.", "WarningMsg" } }, false, {})
			return
		end
		find_next_heading(level)
	end, { desc = "Jump to next H" .. level .. " heading" })
end

-- ------------------------- table formatting
vim.api.nvim_create_user_command("MDTablesNumber", function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local new_lines = {}
	local placeholder_pattern = "_Таблица ([%d#])%. (.*)" -- Matches any placeholder (with # or a number and any description)
	local table_count = 0

	for _, line in ipairs(lines) do
		-- Check if the line is a placeholder
		local number_or_hash, description = line:match(placeholder_pattern)
		if number_or_hash then
			table_count = table_count + 1
			-- Replace the number (or #) with the current table count, but keep the description
			line = "_Таблица " .. table_count .. ". " .. (description or "TODO")
		end
		table.insert(new_lines, line)
	end

	-- Replace the buffer with the modified lines
	vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
	print("Table placeholders updated: " .. table_count .. " tables found.")
end, {})
