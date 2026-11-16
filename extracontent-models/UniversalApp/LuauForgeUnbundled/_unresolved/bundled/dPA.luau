local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dPB")

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		local bundleId = p3.bundleId

		return Cryo.Dictionary.join(p2, { [bundleId] = p3.isFavorited })
	end
})
