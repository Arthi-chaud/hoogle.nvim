local M = {}

---@param item snoogle.SearchItem
---@return string
function M.formatItemLine(item)
	if item.pkg ~= nil then
		return string.format("package %s", item.pkg.name)
	elseif item.module ~= nil then
		return string.format("module %s (%s)", item.module.name, item.module.package.name)
	elseif item.symbol ~= nil then
		return string.format(
			"%s :: %s (%s) [%s]",
			item.symbol.name,
			item.symbol.signature,
			item.symbol.module.name,
			item.symbol.module.package.name
		)
	end
end

---@param item snoogle.SearchItem
---@return string
function M.formatItemPreview(item)
	local header = ""
	local header_top = "\n"
	if item.pkg ~= nil then
		header = string.format("%spackage %s", header_top, item.pkg.name)
	elseif item.module ~= nil then
		header = string.format("%smodule %s \\(%s\\)", header_top, item.module.name, item.module.package.name)
	elseif item.symbol ~= nil then
		header = string.format(
			"%s```haskell\n%s :: %s\n-- From %s in '%s'\n```",
			header_top,
			item.symbol.name,
			item.symbol.signature,
			item.symbol.module.name,
			item.symbol.module.package.name
		)
	end
	return string.format("%s\n----\n\n%s", header, M.formatPreview(item.htmlDoc))
end

--- @private
--- Tries to turn html into markdown
--- @param s string
--- @return string
function M.formatPreview(s)
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
