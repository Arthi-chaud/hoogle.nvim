local M = {}

--- @class hoogle.State
--- @field config? hoogle.Config

--- @private
--- @type hoogle.State
M._state = {}

--- @param c hoogle.Config
function M.set_config(c)
	M._state.config = c
end

--- @return hoogle.Config
function M.get_config()
	if M._state.config ~= nil then
		return M._state.config
	end
	vim.notify("Snoogle: State has not been initialised. This might be a bug", vim.log.levels.ERROR)
	error("Snoogle failure")
end

return M
