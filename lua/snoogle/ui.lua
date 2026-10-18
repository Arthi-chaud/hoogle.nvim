local M = {}

---@param symbol snoogle.SearchItem.Symbol
---@return snoogle.ui.HighlightedLineSegment
function M.format_symbol_line_trailing(symbol)
	return {
		text = string.format(" (%s) [%s]", symbol.module.name, symbol.module.package.name),
		hl_group = "@comment",
	}
end

--- @alias snoogle.ui.HighlightedLine snoogle.ui.HighlightedLineSegment[]
---
--- @class snoogle.ui.HighlightedLineSegment
--- @field text string
--- @field hl_group string

---@param p snoogle.SearchItem.Package
---@return snoogle.ui.HighlightedLine
function M.format_package_line(p)
	--- @type snoogle.ui.HighlightedLine
	local segments = {
		{ text = "package ", hl_group = "@keyword" },
		{ text = p.name, hl_group = "@namespace" },
	}

	return segments
end

---@param m snoogle.SearchItem.Module
---@return snoogle.ui.HighlightedLine
function M.format_module_line(m)
	--- @type snoogle.ui.HighlightedLine
	local segments = {
		{ text = "module ", hl_group = "@keyword" },
		{ text = m.name, hl_group = "@namespace" },
		{ text = string.format(" (%s)", m.package.name), hl_group = "@comment" },
	}

	return segments
end

---@param item snoogle.SearchItem
---@return string
function M.format_item_preview(item)
	local header = ""
	local header_top = "\n"
	if item.pkg ~= nil then
		header = string.format("%spackage %s", header_top, item.pkg.name)
	elseif item.module ~= nil then
		header = string.format("%smodule %s \\(%s\\)", header_top, item.module.name, item.module.package.name)
	elseif item.symbol ~= nil then
		header = string.format(
			"%s```haskell\n%s\n-- From %s in '%s'\n```",
			header_top,
			item.symbol.name,
			item.symbol.module.name,
			item.symbol.module.package.name
		)
	end
	return string.format("%s\n----\n\n%s", header, M.html_doc_to_md(item.htmlDoc))
end

--- @private
--- Tries to turn html into markdown
--- @param s string
--- @return string
function M.html_doc_to_md(s)
	local res, _ = s:gsub("&lt;", "<")
		:gsub("&gt;", ">")
		:gsub("&amp", "&")
		:gsub("<a>", "`")
		:gsub("</a>", "`")
		:gsub("<tt>", "`")
		:gsub("</tt>", "`")
		:gsub("<b>", "**")
		:gsub("</b>", "**")
		:gsub("<i>", "_")
		:gsub("</i>", "_")
		:gsub("<pre>", "```haskell\n")
		:gsub("</pre>", "\n```")
		:gsub("<h4>", "#### ")
		:gsub("</h4>", "")

	return res
end
return M
