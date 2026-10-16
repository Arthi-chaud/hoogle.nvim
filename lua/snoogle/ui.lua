--- @class snoogle.FormattedSearchItem
--- @field text string

local M = {}

---@param item snoogle.SearchItem
---@return snoogle.FormattedSearchItem
function M.formatItem(item)
	if item.pkg ~= nil then
		return { text = string.format("package %s", item.pkg.name) }
	elseif item.module ~= nil then
		return { text = string.format("module %s (%s)", item.module.name, item.module.package.name) }
	elseif item.symbol ~= nil then
		return {
			text = string.format(
				"%s :: %s (%s) [%s]",
				item.symbol.name,
				item.symbol.signature,
				item.symbol.module.name,
				item.symbol.module.package.name
			),
		}
	end
end

return M
