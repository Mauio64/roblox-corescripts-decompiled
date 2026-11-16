local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dTo")
local v5 = { finalPageViewMode = require("@luauforge/bundled/dTh").Closeup }

return Rodux.createReducer(v5, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { finalPageViewMode = p3.finalPageViewMode })
	end
})
