local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dWU")

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		return p3.savedAccessories
	end
})
