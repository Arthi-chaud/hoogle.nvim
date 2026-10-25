local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local cmd = require("snoogle.core.cmd")
local model = require("snoogle.core.model")

--- @param opts table
function M.picker(opts)
	--- @type snoogle.CmdOpts
	local cmd_opts = { count = 25 }
	--TODO: set cwd, entry maker, bin

	pickers
		.new(opts, {

			-- NOTE: https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#picker
			prompt_title = "Hoogle",
			finder = finders.new_async_job({
				command_generator = function(query)
					return cmd.get_cmd(cmd_opts, query)
				end,
				entry_maker = function(item)
					local data = cmd.parse_output_line(item)
					return { value = data, display = model.get_name(item) }
				end,
				cwd = opts.cwd or vim.fn.getcwd,
			}),
			previewer = nil, -- TODO:!
			-- attach_mappings = function()
			-- 	-- TODO:!
			-- end,
		})
		:find()
end

return M
