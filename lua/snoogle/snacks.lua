local M = {}

---@module 'snacks'

local hoogle = require("snoogle.core.cmd")
local model = require("snoogle.core.model")
local utils = require("snoogle.core.utils")
local picker_proc = require("snacks.picker.source.proc")
local actions = require("snoogle.actions")
local settings = require("snoogle.settings")
local line = require("snoogle.ui.line")
local preview = require("snoogle.ui.preview")

---@param opts snoogle.Config
function M.get_finder(opts)
	local use_stack = utils.should_use_stack(opts)

	---@type snacks.picker.finder
	return function(_, ctx)
		if ctx.filter.search == "" then
			return function() end
		end

		local cmd, args = hoogle.get_cmd({
			use_stack = use_stack,
			db_path = opts.db_path,
			count = opts.limit or settings.DEFAULT_LIMIT,
		}, ctx.filter.search)

		return picker_proc.proc(

			ctx:opts({
				notify = true,
				cmd = cmd,
				args = args,
				--- @type snacks.picker.transform
				transform = function(item)
					local parsed = hoogle.parse_output_line(item.text)
					if parsed == nil then
						return false
					end
					local entry = model.from_hoogle(parsed)
					if entry == nil then
						return false
					end
					item.data = entry
					return item
				end,
			}),
			ctx
		)
	end
end

--- @param segments snoogle.HighlightedText
--- @return snacks.picker.Highlight[][]
local function to_snacks_highlights(segments)
	local hl = {}
	for _, segment in ipairs(segments) do
		if segment.highlights ~= nil then
			for _, h in ipairs(segment.highlights or {}) do
				hl[#hl + 1] = {
					hl_group = h.hl_group,
					col = h.start_,
					end_col = h.end_,
					priority = h.priority,
				}
			end
			hl[#hl + 1] = { segment.text }
		else
			hl[#hl + 1] = { segment.text, segment.default_hl }
		end
	end
	return hl
end

--- @param opts snoogle.Config
--- @return snacks.picker.Config
function M.get_source(opts)
	return {
		prompt = ">>= ",
		notify = true,
		layout = { cycle = true },
		finder = M.get_finder(opts),
		live = true,
		preview = "preview",
		show_delay = 500,
		show_empty = true,
		transform = function(item)
			item.preview = {
				text = preview.format_item_preview(item.data),
				ft = "markdown",
			}
		end,
		format = function(item)
			---@type snoogle.SearchItem
			local data = item.data

			if data.symbol ~= nil then
				return to_snacks_highlights(line.format_symbol_line(data.symbol))
			elseif data.module ~= nil then
				return to_snacks_highlights(line.format_module_line(data.module))
			elseif data.pkg ~= nil then
				return to_snacks_highlights(line.format_package_line(data.pkg))
			end
		end,
		actions = {
			open_browser = function(_, item, _)
				local data = item.data
				--- @cast data snoogle.SearchItem
				actions.open_browser(model.get_url(data))
			end,
			copy_to_clipboard = function(self, item, _)
				local data = item.data
				--- @cast data snoogle.SearchItem
				Snacks.notify.info("Copied to clipboard!")
				self:close()
				actions.copy_to_clipboard(model.get_name(data))
			end,
		},
	}
end

return M
