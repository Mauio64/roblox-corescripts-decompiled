local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dWO")
local module2 = require("@luauforge/bundled/dWP")

return Rodux.createReducer(module2.Position, {
	[module.name] = function(p2, p3)
		return p3.adjustmentType
	end
})
