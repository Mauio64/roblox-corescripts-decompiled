local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dLR")
local module2 = require("@luauforge/bundled/dLS")

return Rodux.createReducer(false, {
	[module.name] = function(p2, p3): boolean
		return true
	end,
	[module2.name] = function(p2, p3): boolean
		return false
	end
})
