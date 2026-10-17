-- Source: https://github.com/ndmitchell/blob/df554c496c676874a889cc6526e154c2d8b5bc7d/src/Input/Item.hs#L112

--- @class snoogle.hoogle.SearchItem
--- @field docs string -- HTML documentation to show
--- @field item string -- HTML span of the item
--- @field type "package" | "module" | ""
--- @field url string
--- @field module snoogle.hoogle.SearchItem.Module
--- @field package snoogle.hoogle.SearchItem.Package

--- @class snoogle.hoogle.SearchItem.Module -- fields will be omitted if the parent item is of that type
--- @field name? string
--- @field url? string

--- @class snoogle.hoogle.SearchItem.Package -- fields will be omitted if the parent item is of that type
--- @field name? string
--- @field url? string

--- @class snoogle.SearchItem
--- @field htmlDoc string
--- @field symbol? snoogle.SearchItem.Symbol
--- @field pkg? snoogle.SearchItem.Package
--- @field module? snoogle.SearchItem.Module

--- @class snoogle.SearchItem.Symbol
--- @field name string The name of the symbol
--- @field signature string | nil The type signature
--- @field module snoogle.SearchItem.Module The module exporting the symbol
--- @field url string

--- @class snoogle.SearchItem.Module
--- @field name string The name of the module
--- @field package snoogle.SearchItem.Package
--- @field url string

--- @class snoogle.SearchItem.Package
--- @field name string The name of the package
--- @field url string

--- @param s string
--- @param prefix string
--- @return string
local function remove_prefix(s, prefix)
	if s:sub(0, prefix:len()) == prefix then
		return s:sub(prefix:len() + 1)
	end
	return s
end

--- @param s string map :: (a -> b) -> f a -> f b
--- @return string,string | nil
local function parse_symbol(s)
	for fname, sig in string.gmatch(s, "(.+) :: (.+)") do
		return fname, sig
	end
	return s, nil
end

local M = {}

--- @param item snoogle.hoogle.SearchItem
--- @return snoogle.SearchItem | nil
function M.from_hoogle(item)
	---@type snoogle.SearchItem
	local result = { htmlDoc = item.docs, symbol = nil, module = nil, pkg = nil }

	if item.type == "" then
		local symbol_name, symbol_signature = parse_symbol(item.item)
		result.symbol = {
			name = symbol_name,
			signature = symbol_signature,
			url = item.url,
			module = {
				name = item.module.name or "",
				url = item.module.url or "",
				package = {
					name = item.package.name or "",
					url = item.package.url or "",
				},
			},
		}
	elseif item.type == "module" then
		local module_name = remove_prefix(item.item, "module ")
		result.module = {
			name = module_name,
			url = item.url,
			package = {
				name = item.package.name or "",
				url = item.package.url or "",
			},
		}
	elseif item.type == "package" then
		local package_name = remove_prefix(item.item, "package ")
		result.pkg = { name = package_name, url = item.url }
	else
		vim.notify(string.format("Invalid hoogle item type: {}", item.type), vim.log.levels.WARN)
		return nil
	end

	return result
end

--- @param item snoogle.SearchItem
--- @return string
function M.get_url(item)
	if item.module ~= nil then
		return item.module.url
	elseif item.pkg ~= nil then
		return item.pkg.url
	elseif item.symbol ~= nil then
		return item.symbol.url
	end
end

--- @param item snoogle.SearchItem
--- @return string
function M.get_name(item)
	if item.module ~= nil then
		return item.module.name
	elseif item.pkg ~= nil then
		return item.pkg.name
	elseif item.symbol ~= nil then
		return item.symbol.name
	end
end

return M
