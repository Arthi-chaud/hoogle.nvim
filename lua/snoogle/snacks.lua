local M = {}

---@module 'snacks'

---@param opts snoogle.Config
function M.get_finder(opts)
	---@type snacks.picker.finder
	return function(_, ctx)
		if ctx.filter.search == "" then
			return function() end
		end

		local use_stack = opts.use_stack ~= nil
				and (type(opts.use_stack) == "boolean" and (opts.use_stack == true) or (require("snoogle.core.stack").is_in_stack_project(
					ctx:cwd()
				)))
			or false
		--- @cast use_stack boolean

		local cmd, args = require("snoogle.core.cmd").get_cmd({
			use_stack = use_stack,
			count = opts.limit or 25,
		}, ctx.filter.search)

		return require("snacks.picker.source.proc").proc(

			ctx:opts({
				notify = true,
				cmd = cmd,
				args = args,
				--- @type snacks.picker.transform
				transform = function(item)
					local parsed = require("snoogle.core.cmd").parse_output_line(item.text)
					if parsed == nil then
						return false
					end
					local entry = require("snoogle.core.model").from_hoogle(parsed)
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

--- @param segments snoogle.ui.HighlightedLine
--- @return snacks.picker.Highlight[]
local function highlighted_line_to_highlights(segments)
	--- @type snacks.picker.Highlight[]
	local hl = {}
	for _, segment in ipairs(segments) do
		hl[#hl + 1] = { segment.text, segment.hl_group }
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
			local ui = require("snoogle.ui")
			item.preview = {
				text = ui.format_item_preview(item.data),
				ft = "markdown",
			}
		end,
		format = function(item)
			local ui = require("snoogle.ui")
			---@type snoogle.SearchItem
			local data = item.data

			if data.symbol ~= nil then
				--- @type snacks.picker.Highlight[]
				local ret = {}
				Snacks.picker.highlight.format(item, data.symbol.name, ret, { lang = "haskell" })
				local trailing_segment = ui.format_symbol_line_trailing(data.symbol)
				ret[#ret + 1] = { trailing_segment.text, trailing_segment.hl_group }
				return ret
			elseif data.module ~= nil then
				return highlighted_line_to_highlights(ui.format_module_line(data.module))
			elseif data.pkg ~= nil then
				return highlighted_line_to_highlights(ui.format_package_line(data.pkg))
			end
		end,
		actions = {
			open_browser = function(_, item, _)
				local data = item.data
				--- @cast data snoogle.SearchItem
				local actions = require("snoogle.actions")
				local models = require("snoogle.core.model")
				actions.open_browser(models.get_url(data))
			end,
			copy_to_clipboard = function(self, item, _)
				local data = item.data
				--- @cast data snoogle.SearchItem
				local actions = require("snoogle.actions")
				local models = require("snoogle.core.model")
				Snacks.notify.info("Copied to clipboard!")
				self:close()
				actions.copy_to_clipboard(models.get_name(data))
			end,
		},
	}
end

return M
