local M = {}

--- @param opts snoogle.Config
function M.setup(opts)
	require("snoogle.state").set_config(opts)
	if Snacks and pcall(require, "snacks.picker") then
		Snacks.picker.sources.hoogle = require("snoogle.snacks").get_source()
	end

	local has_telescope, telescope = pcall(require, "telescope")
	if has_telescope then
		telescope.load_extension("hoogle")
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
