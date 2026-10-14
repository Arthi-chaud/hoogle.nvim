local M = {}

---@module 'snacks'

---@class snacks.picker.hoogle.Config
---@field use_stack? boolean
---@field count? integer

---@param opts snacks.picker.hoogle.Config
---@type snacks.picker.finder
function finder(opts, ctx)
	if ctx.filter.search == "" then
		return function() end
	end
	local cmd, args =
		require("snoogle.core.cmd").get_cmd({ use_stack = opts.use_stack, count = opts.count }, ctx.filter.search)

	return require("snacks.picker.source.proc").json(
		ctx:opts({
			notify = true,
			cmd = cmd,
			args = args,
			--TODO: Transform
		}),
		ctx
	)
end

---@type snacks.picker.hoogle.Config|{}
M.source = {
	prompt = ">>= ",
	notify = false,
	layout = { cycle = true },

	--- @param opts snacks.picker.hoogle.Config
	--- @type snacks.picker.finder
	finder = finder,
}

return M
