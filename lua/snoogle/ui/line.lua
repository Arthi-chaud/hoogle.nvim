local M = {}

---@param symbol snoogle.SearchItem.Symbol
---@return snoogle.HighlightedText
function M.format_symbol_line(symbol)
	local ret = require("snoogle.highlight").highlight_text({ code = symbol.decl })
	ret[#ret + 1] = {
		text = string.format(" (%s) [%s]", symbol.module.name, symbol.module.package.name),
		default_hl = "@comment",
	}
	return ret
end

---@param p snoogle.SearchItem.Package
---@return snoogle.HighlightedText
function M.format_package_line(p)
	---@type snoogle.HighlightedText
	local segments = {
		{ text = "package ", default_hl = "@keyword" },
		{ text = p.name, default_hl = "@namespace" },
	}

	return segments
end

---@param m snoogle.SearchItem.Module
---@return snoogle.HighlightedText
function M.format_module_line(m)
	--- @type snoogle.HighlightedText
	local segments = {
		{ text = "module ", default_hl = "@keyword" },
		{ text = m.name, default_hl = "@namespace" },
		{ text = string.format(" (%s)", m.package.name), default_hl = "@comment" },
	}

	return segments
end

return M
