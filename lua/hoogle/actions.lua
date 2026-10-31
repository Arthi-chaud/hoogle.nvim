local M = {}

--- @source https://github.com/luc-tielen/telescope_hoogle/blob/master/lua/telescope/_extensions/hoogle/live_hoogle_search.lua#L91
function M.open_browser(url)
	local browser_cmd
	if vim.fn.has("unix") == 1 then
		if vim.fn.executable("sensible-browser") == 1 then
			browser_cmd = "sensible-browser"
		else
			browser_cmd = "xdg-open"
		end
	end
	if vim.fn.has("mac") == 1 then
		browser_cmd = "open"
	end
	if vim.fn.has("windows") == 1 then
		if vim.fn.executable("explorer") == 1 then
			browser_cmd = "explorer"
		end
	end

	vim.cmd(":silent !" .. browser_cmd .. " " .. vim.fn.fnameescape(url))
end

--- @source  https://github.com/folke/snacks.nvim/blob/882c996cf28183f4d63640de0b4c02ec886d01f2/lua/snacks/explorer/actions.lua#L139
function M.copy_to_clipboard(text)
	vim.fn.setreg(vim.v.register or "+", text, "l")
end

return M
