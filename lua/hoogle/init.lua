local M = {}

--- @param opts hoogle.Config
function M.setup(opts)
	require("hoogle.state").set_config(opts)
	if Snacks and pcall(require, "snacks.picker") then
		Snacks.picker.sources.hoogle = require("hoogle.snacks").get_source()
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
