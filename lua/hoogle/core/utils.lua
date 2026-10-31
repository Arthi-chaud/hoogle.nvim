local M = {}

local stack = require("hoogle.core.stack")

--- @param config hoogle.Config
--- @return boolean
function M.should_use_stack(config)
	if config.use_stack == nil then
		return false
	elseif type(config.use_stack) == "boolean" then
		local res = config.use_stack
		--- @cast res boolean
		return res
	else -- NOTE: Assuming use_stack === "in_project"
		return stack.is_in_stack_project(vim.fn.getcwd())
	end
end

return M
