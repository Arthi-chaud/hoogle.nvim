return require("telescope").register_extension({
	exports = {
		hoogle = require("snoogle.telescope").picker,
	},
})
