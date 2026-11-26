local module = require("@luauforge/bundled/dAZ")

local module2 = require("@luauforge/bundled/dAY")

return module.createReducer("", {
	[module2.name] = function(p2, p3)
		return p3.countryCode
	end
})
