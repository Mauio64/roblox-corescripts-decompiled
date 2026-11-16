local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dTw")

return Rodux.createReducer(nil, {
	[module.name] = function(p2, p3)
		return p3.selectedAccessory
	end
})
