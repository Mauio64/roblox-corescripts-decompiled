local module = require("@luauforge/bundled/dxW")

local module2 = require("@luauforge/bundled/dxV")

return module.createReducer("", {
	[module2.name] = function(p2, p3)
		return p3.countryCode
	end
})
