local M = {}

local highlights = require("hoogle.highlight")

---@param symbol hoogle.SearchItem.Symbol
---@return hoogle.HighlightedText
function M.format_symbol_line(symbol)
	local ret = highlights.highlight_text({ code = symbol.decl })
	ret[#ret + 1] = {
		text = string.format(" (%s) [%s]", symbol.module.name, symbol.module.package.name),
		default_hl = "@comment",
	}
	return ret
end

---@param p hoogle.SearchItem.Package
---@return hoogle.HighlightedText
function M.format_package_line(p)
	---@type hoogle.HighlightedText
	local segments = {
		{ text = "package ", default_hl = "@keyword" },
		{ text = p.name, default_hl = "@namespace" },
	}

	return segments
end

---@param m hoogle.SearchItem.Module
---@return hoogle.HighlightedText
function M.format_module_line(m)
	--- @type hoogle.HighlightedText
	local segments = {
		{ text = "module ", default_hl = "@keyword" },
		{ text = m.name, default_hl = "@namespace" },
		{ text = string.format(" (%s)", m.package.name), default_hl = "@comment" },
	}

	return segments
end

---@param data hoogle.SearchItem
---@return hoogle.HighlightedText
function M.format_line(data)
	if data.symbol ~= nil then
		return M.format_symbol_line(data.symbol)
	elseif data.module ~= nil then
		return M.format_module_line(data.module)
	elseif data.pkg ~= nil then
		return M.format_package_line(data.pkg)
	end
end

return M
