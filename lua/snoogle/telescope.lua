local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local state = require("snoogle.state")
local settings = require("snoogle.settings")
local utils = require("snoogle.core.utils")
local cmd = require("snoogle.core.cmd")
local model = require("snoogle.core.model")
local ui_line = require("snoogle.ui.line")
local ui_preview = require("snoogle.ui.preview")
local entry_display = require("telescope.pickers.entry_display")
local action_state = require("telescope.actions.state")
local actions = require("snoogle.actions")
local telescope_actions = require("telescope.actions")

local displayer = entry_display.create({
	separator = " ",
	items = {
		{ remaining = true },
	},
})

local function splitToLines(input, delimiter)
	local result = {}
	local idx = 1
	local start, end_ = string.find(input, delimiter, idx)
	while start do
		table.insert(result, string.sub(input, idx, start - 1))
		idx = end_ + 1
		start, end_ = string.find(input, delimiter, idx)
	end
	table.insert(result, string.sub(input, idx))
	return result
end

--- @param entry {value: snoogle.SearchItem}
local function make_display(entry)
	local text = ""
	--- @type {[1]: {[1]: number, [2]: number}, [2]: string}[]
	local highlights = {}
	local line = ui_line.format_line(entry.value)
	for _, segment in ipairs(line) do
		local text_len = text:len()
		text = text .. segment.text
		if segment.highlights == nil then
			highlights[#highlights + 1] = {
				{ text_len, text_len + segment.text:len() },
				segment.default_hl,
			}
		else
			for _, hl in ipairs(segment.highlights) do
				highlights[#highlights + 1] = {
					{ text_len + hl.start_, text_len + hl.end_ },
					hl.hl_group,
				}
			end
		end
	end
	return displayer({ text }), highlights
end

--- @param opts table
function M.picker(opts)
	local config = state.get_config()
	local use_stack = utils.should_use_stack(config)

	pickers
		.new(opts, {

			-- NOTE: https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#picker
			prompt_title = "Hoogle",
			attach_mappings = function(bufnr, map)
				for key, action_name in pairs(opts) do
					local callback = function()
						if action_name == "open_browser" then
							local action = action_state.get_selected_entry()
							local data = action.value
							--- @cast data snoogle.SearchItem
							actions.open_browser(model.get_url(data))
						elseif action_name == "copy_to_clipboard" then
							local action = action_state.get_selected_entry()
							local data = action.value
							--- @cast data snoogle.SearchItem
							vim.notify("Copied to clipboard!", vim.log.levels.INFO)
							telescope_actions.close(bufnr)
							actions.copy_to_clipboard(model.get_name(data))
						end
					end
					map("i", key, callback)
					map("n", key, callback)
				end

				return true
			end,
			finder = finders.new_async_job({
				command_generator = function(query)
					if not query or string.len(query) < 2 then
						return nil
					end
					local exec, args = cmd.get_cmd({
						use_stack = use_stack,
						db_path = config.db_path,
						count = config.limit or settings.DEFAULT_LIMIT,
					}, query)
					table.insert(args, 1, exec)
					local command = args
					return command
				end,
				entry_maker = function(entry_str)
					local parsed_data = cmd.parse_output_line(entry_str)
					if parsed_data == nil then
						return nil
					end
					local data = model.from_hoogle(parsed_data)
					if data == nil then
						return nil
					end
					return {
						value = data,
						ordinal = 1,
						display = make_display,
					}
				end,
			}),
			previewer = previewers.new_buffer_previewer({
				dynamic_title = function(_, entry)
					--- @type snoogle.SearchItem
					local value = entry.value
					return model.get_name(value)
				end,
				define_preview = function(self, entry)
					--- @type snoogle.SearchItem
					local value = entry.value
					local markdown = ui_preview.format_item_preview(value)
					vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, true, splitToLines(markdown, "\n"))
					vim.bo[self.state.bufnr].filetype = "markdown"
					vim.bo[self.state.bufnr].syntax = "markdown"
					-- TODO:
					-- require("render-markdown").render({
					-- 	buf = self.state.bufnr,
					-- 	config = {
					-- 		render_modes = true,
					-- 		bullet = { enabled = opts.bullets ~= false },
					-- 	},
					-- })
				end,
			}),
		})
		:find()
end

return M
