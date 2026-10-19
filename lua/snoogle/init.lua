local M = {}

--- @param opts snoogle.Config
function M.setup(opts)
	if Snacks and pcall(require, "snacks.picker") then
		Snacks.picker.sources.hoogle = require("snoogle/snacks").get_source(opts)
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
