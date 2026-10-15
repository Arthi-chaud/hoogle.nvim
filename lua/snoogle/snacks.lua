local M = {}

---@module 'snacks'

---@class snacks.picker.hoogle.Config
---@field use_stack? boolean
---@field count? integer

---@param opts snacks.picker.hoogle.Config
---@type snacks.picker.finder
local function finder(opts, ctx)
	if ctx.filter.search == "" then
		return function() end
	end

	local cmd, args = require("snoogle.core.cmd").get_cmd({
		use_stack = opts.use_stack,
		count = opts.count or 25,
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
					return nil
				end
				local entry = require("snoogle.core.model").from_hoogle(parsed)
				if entry == nil then
					return nil
				end

				if entry.symbol ~= nil then
					item.line = entry.symbol.name
					item.preview = { text = entry.htmlDoc, ft = "html" }
				elseif entry.pkg ~= nil then
					item.line = entry.pkg.name
				elseif entry.module ~= nil then
					item.line = entry.module.name
				end

				return item
			end,
		}),
		ctx
	)
end

--- @type snacks.picker.Config
M.source = {
	prompt = ">>= ",
	notify = true,
	layout = { cycle = true },
	finder = finder,
	live = true,
	show_delay = 500,
	show_empty = true,
}

return M
