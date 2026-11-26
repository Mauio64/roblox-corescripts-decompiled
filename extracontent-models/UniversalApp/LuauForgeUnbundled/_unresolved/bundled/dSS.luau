local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dST")

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		local assetId = p3.assetId

		return Cryo.Dictionary.join(p2, { [assetId] = p3.isFavorited })
	end
})
