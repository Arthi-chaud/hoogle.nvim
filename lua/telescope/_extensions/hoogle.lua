local mappings = {}

return require("telescope").register_extension({
	setup = function(e, _)
		for key, _mappings in pairs(e) do
			if key == "mappings" and type(_mappings) == "table" then
				mappings = _mappings
				break
			end
		end
	end,
	exports = {
		hoogle = function()
			require("snoogle.telescope").picker(mappings)
		end,
	},
})
