local M = {}

---@class snoogle.cmdOpts
---@field use_stack? boolean
---@field count? integer

--- @param opts snoogle.cmdOpts
--- @param query string
function M.get_cmd(opts, query)
	local cmd = "hoogle"
	local args = {}

	if opts.use_stack then
		cmd = "stack"
		args = { "hoogle", "--no-setup", "--" }
	end

	table.insert(args, query)

	table.insert(args, "--json")

	table.insert(args, "--count")
	table.insert(args, tostring(opts.count))

	return cmd, args
end

return M
