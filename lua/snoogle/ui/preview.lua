local M = {}

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
			item.symbol.decl,
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
		:gsub("&amp;", "&")
		:gsub("<a>", "")
		:gsub("</a>", "")
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
		:gsub("<ul>", "")
		:gsub("</ul>", "")
		:gsub("<li>", "- ")
		:gsub("</li>", "")

	return res
end
return M
