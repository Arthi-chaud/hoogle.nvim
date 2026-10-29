--- @alias snoogle.UseStack "in_project" | boolean

---@class snoogle.Config
---@field use_stack? snoogle.UseStack
---@field db_path? string absolute path to the Hoogle database (.hoo file) to use
---@field limit? integer -- Default to 25

local M = {}

M.DEFAULT_LIMIT = 25

return M
