local M = {}
function M.setup(_)
	if Snacks and pcall(require, "snacks.picker") then
		Snacks.picker.sources.hoogle = require("snoogle/snacks").source
	else
		vim.print("Snacks not found")
	end
end

function M.reset()
	--TODO:
end

function M.disable()
	--TODO:
end

function M.enable()
	--TODO:
end

return M
