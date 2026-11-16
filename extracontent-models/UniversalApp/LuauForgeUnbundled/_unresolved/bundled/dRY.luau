local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dRZ")

local Rodux = require(CorePackages.Packages.Rodux)

local module2 = require("@luauforge/bundled/dSa")

return Rodux.createReducer({}, {
	[module2.name] = function(p2, p3)
		local v6 = module.fromGetResaleTaxRate(p3.marketplaceFeeInfo)
		return Cryo.Dictionary.join(p2, v6)
	end
})
