local module = require("@luauforge/bundled/hKM")

require("@luauforge/bundled/hKL")

return table.freeze({
	tab = function(p2, p3, p4)
		return module.defineRoute(p2, p3, p4)
	end,
	page = function(p2, p3, p4)
		return module.defineRoute(p2, p3, p4)
	end,
	overlay = function(p2, p3, p4)
		return module.defineRoute(p2, p3, p4)
	end
})
