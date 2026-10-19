local M = {}

---@class snoogle.CmdOpts
---@field use_stack? boolean
---@field count integer

--- @param opts snoogle.CmdOpts
--- @param query string
function M.get_cmd(opts, query)
	local cmd = "hoogle"
	local args = {}

	if opts.use_stack then
		cmd = "stack"
		args = { "hoogle", "--no-setup", "--" }
	end

	table.insert(args, query)

	table.insert(args, "--jsonl")

	table.insert(args, "--count")
	table.insert(args, tostring(opts.count))

	return cmd, args
end

---@param out string raw output
---@return snoogle.hoogle.SearchItem | nil
function M.parse_output_line(out)
	if out == "No results found" then
		return nil
	end
	local success, res = pcall(vim.json.decode, out)
	if success then
		return res
	else
		return nil
	end
end
return M
