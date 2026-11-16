local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dLL")

return Rodux.createReducer(0, {
	[module.name] = function(p2, p3)
		return p2 + 1
	end
})
