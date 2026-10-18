local M = {}

--- @alias snoogle.ui.HighlightedLine snoogle.ui.HighlightedLineSegment[]
---
--- @class snoogle.ui.HighlightedLineSegment
--- @field text string
--- @field hl_group string

---@param item snoogle.SearchItem
---@return snoogle.ui.HighlightedLine
function M.format_item_line(item)
	--- @type snoogle.ui.HighlightedLine
	local segments = {}

	if item.pkg ~= nil then
		segments[#segments + 1] = { text = "package ", hl_group = "@keyword" }
		segments[#segments + 1] = { text = item.pkg.name, hl_group = "@namespace" }
	elseif item.module ~= nil then
		segments[#segments + 1] = { text = "module ", hl_group = "@keyword" }
		segments[#segments + 1] = { text = item.module.name, hl_group = "@namespace" }
		segments[#segments + 1] = { text = string.format(" (%s)", item.module.package.name), hl_group = "@comment" }
	elseif item.symbol ~= nil then
		segments[#segments + 1] = { text = item.symbol.name, hl_group = "@constructor" }
		local signature = item.symbol.signature
		if signature ~= nil and signature:len() > 0 then
			segments[#segments + 1] = { text = " :: ", hl_group = "@operator" }
			segments[#segments + 1] = { text = signature, hl_group = "@type" }

			-- for _, t in string.gmatch(signature, "([^" .. "\\s" .. "]+)") do
			-- 	local hl = "@type"
			-- 	if t == "->" then
			-- 		hl = "@operator"
			-- 	end
			-- 	segments[#segments + 1] = { text = t, hl_group = hl }
			-- end
		end
		segments[#segments + 1] = {
			text = string.format(" (%s) [%s]", item.symbol.module.name, item.symbol.module.package.name),
			hl_group = "@comment",
		}
	end

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
			"%s```haskell\n%s :: %s\n-- From %s in '%s'\n```",
			header_top,
			item.symbol.name,
			item.symbol.signature,
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
