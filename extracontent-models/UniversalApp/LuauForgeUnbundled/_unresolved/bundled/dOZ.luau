local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dPa")

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { [p3.assetTypeId] = p3.isFinished })
	end
})
