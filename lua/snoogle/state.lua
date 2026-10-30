local M = {}

--- @class snoogle.State
--- @field config? snoogle.Config

--- @private
--- @type snoogle.State
M._state = {}

--- @param c snoogle.Config
function M.set_config(c)
	M._state.config = c
end

--- @return snoogle.Config
function M.get_config()
	if M._state.config ~= nil then
		return M._state.config
	end
	vim.notify("Snoogle: State has not been initialised. This might be a bug", vim.log.levels.ERROR)
	error("Snoogle failure")
end

return M
