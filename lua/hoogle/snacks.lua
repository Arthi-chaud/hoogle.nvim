local M = {}

---@module 'snacks'

local hoogle = require("hoogle.core.cmd")
local model = require("hoogle.core.model")
local utils = require("hoogle.core.utils")
local picker_proc = require("snacks.picker.source.proc")
local state = require("hoogle.state")
local actions = require("hoogle.actions")
local settings = require("hoogle.settings")
local line = require("hoogle.ui.line")
local preview = require("hoogle.ui.preview")

---@param opts hoogle.Config
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

--- @param segments hoogle.HighlightedText
--- @return snacks.picker.Highlight[][]
function M.to_snacks_highlights(segments)
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

--- @return snacks.picker.Config
function M.get_source()
	return {
		prompt = ">>= ",
		notify = true,
		layout = { cycle = true },
		finder = M.get_finder(state.get_config()),
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
			---@type hoogle.SearchItem
			local data = item.data
			return M.to_snacks_highlights(line.format_line(data))
		end,
		actions = {
			open_browser = function(_, item, _)
				local data = item.data
				--- @cast data hoogle.SearchItem
				actions.open_browser(model.get_url(data))
			end,
			copy_to_clipboard = function(self, item, _)
				local data = item.data
				--- @cast data hoogle.SearchItem
				Snacks.notify.info("Copied to clipboard!")
				self:close()
				actions.copy_to_clipboard(model.get_name(data))
			end,
		},
	}
end

return M
