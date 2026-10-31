local M = {}

---@class hoogle.CmdOpts
---@field use_stack? boolean
---@field count integer
---@field db_path? string

--- @param opts hoogle.CmdOpts
--- @param query string
function M.get_cmd(opts, query)
	local cmd = "hoogle"
	local args = {}

	if opts.use_stack then
		cmd = "stack"
		args = { "hoogle", "--no-setup", "--" }
	end

	if opts.db_path ~= nil then
		table.insert(args, "--database")
		table.insert(args, opts.db_path)
	end

	table.insert(args, "--jsonl")

	table.insert(args, "--count")
	table.insert(args, tostring(opts.count))

	-- NOTE: if query is the first arg, if it _looks like_ the "generate" keyword
	-- if will fail, as it will run "hoogle generate"
	table.insert(args, query)

	return cmd, args
end

---@param out string raw output
---@return hoogle.hoogle.SearchItem | nil
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
