local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dAV")

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		local tableOfHumanoidDescriptionProperties = p3.tableOfHumanoidDescriptionProperties

		return Cryo.Dictionary.join(p2, tableOfHumanoidDescriptionProperties)
	end
})
