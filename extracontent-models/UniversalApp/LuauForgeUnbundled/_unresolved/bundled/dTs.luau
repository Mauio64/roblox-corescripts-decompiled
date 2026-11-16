local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dTt")
local module2 = require("@luauforge/bundled/dTu")

return Rodux.createReducer(module2.Position, {
	[module.name] = function(p2, p3)
		return p3.adjustmentType
	end
})
