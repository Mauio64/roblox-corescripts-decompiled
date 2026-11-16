local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dSQ")

return Rodux.createReducer({ obtainedCatalogMetadata = false }, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join({ obtainedCatalogMetadata = true }, p3.metadata)
	end
})
