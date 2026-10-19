-- NOTE: Copied from Snacks' utils for git
local M = {}

local stack_cache = {} ---@type table<string, boolean>
local function is_stack_root(dir)
	if stack_cache[dir] == nil then
		stack_cache[dir] = (vim.uv or vim.loop).fs_stat(dir .. "/stack.yaml.lock") ~= nil
	end
	return stack_cache[dir]
end

--- Gets the stack root for a buffer or path.
--- Defaults to the current buffer.
---@param path? number|string buffer or path
---@return string?
function M.is_in_stack_project(path)
	path = path or 0
	path = type(path) == "number" and vim.api.nvim_buf_get_name(path) or path --[[@as string]]
	path = path == "" and (vim.uv or vim.loop).cwd() or path
	path = svim.fs.normalize(path)

	if is_stack_root(path) then
		return path
	end

	for dir in vim.fs.parents(path) do
		if is_stack_root(dir) then
			return svim.fs.normalize(dir)
		end
	end

	return nil
end

return M
