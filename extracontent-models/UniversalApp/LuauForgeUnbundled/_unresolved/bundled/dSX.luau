local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dSY")

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, {
			searchUuid = p3.searchUuid,
			keyword = p3.keyword
		})
	end
})
