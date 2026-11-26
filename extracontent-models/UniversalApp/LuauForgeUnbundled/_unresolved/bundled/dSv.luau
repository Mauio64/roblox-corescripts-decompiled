local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dSw")

return Rodux.createReducer(false, {
	[module.name] = function(p2, p3)
		return p3.value
	end
})
