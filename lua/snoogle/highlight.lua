local M = {}

M._scratch = {} ---@type table<string, number>

--- @class snoogle.HighlightedTextSegment
--- @field text string
--- @field default_hl string
--- @field highlights? { start_: number, end_: number, hl_group: string, priority: number }[]

--- @alias snoogle.HighlightedText snoogle.HighlightedTextSegment[]

--- @param opts { code: string, }
function M.highlight_text(opts)
	local lang = "haskell"
	local ret = { text = opts.code, default_hl = "@text", highlights = {} } ---@type snoogle.HighlightedTextSegment

	local parser, buf ---@type vim.treesitter.LanguageTree?, number?

	local ok = false
	buf = M.scratch_buf(opts.code, lang)
	ok, parser = pcall(vim.treesitter.get_parser, buf, lang)
	parser = ok and parser or nil

	if not (parser and buf) then
		return ret
	end
	parser:parse(true)
	parser:for_each_tree(function(tstree, tree)
		if not tstree then
			return
		end
		local query = vim.treesitter.query.get(tree:lang(), "highlights")
		if not query then
			return
		end

		for capture, node, metadata in query:iter_captures(tstree:root(), buf) do
			---@type string
			local name = query.captures[capture]
			if name ~= "spell" then
				local range = { node:range() } ---@type number[]
				local start_col = range[2]
				local end_col = range[4]
				local priority = (
					tonumber(metadata.priority or metadata[capture] and metadata[capture].priority) or 100
				)
				table.insert(
					ret.highlights,
					{ start_ = start_col, end_ = end_col, hl_group = "@" .. name .. "." .. "lang", priority = priority }
				)
			end
		end
	end)
	return { ret }
end

---@param source string
---@param lang string
function M.scratch_buf(source, lang)
	local buf = M._scratch[lang]
	if not (buf and vim.api.nvim_buf_is_valid(buf)) then
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(buf, "snoggle://line_highlight/" .. lang)
		M._scratch[lang] = buf
	end
	vim.bo[buf].fixeol = false
	vim.bo[buf].eol = false
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(source, "\n", { plain = true }))
	return buf
end

return M
