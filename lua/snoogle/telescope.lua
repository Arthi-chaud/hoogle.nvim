local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local cmd = require("snoogle.core.cmd")
local model = require("snoogle.core.model")
local ui = require("snoogle.ui.line")
local entry_display = require("telescope.pickers.entry_display")

local displayer = entry_display.create({
	separator = " ",
	items = {
		{ remaining = true },
	},
})

--- @param entry {value: snoogle.SearchItem}
local function make_display(entry)
	local text = ""
	local line = ui.format_line(entry.value)
	for _, segment in ipairs(line) do
		text = text .. segment.text
	end
	return displayer({ text }) -- TODO: highlights
end

--- @param opts table
function M.picker(opts)
	--- @type snoogle.CmdOpts
	local cmd_opts = { count = 25 } --TODO:

	pickers
		.new(opts, {

			-- NOTE: https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#picker
			prompt_title = "Hoogle",
			finder = finders.new_async_job({
				command_generator = function(query)
					if not query or string.len(query) < 2 then
						return nil
					end
					local exec, args = cmd.get_cmd(cmd_opts, query)
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
						-- TODO: return line and highlight seperatedly
						display = make_display,
					}
				end,
			}),
		})
		:find()
end

return M
