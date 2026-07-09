local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetHumanoidDescriptionProperties = require(Modules.LuaApp.Actions.Authentication.SetHumanoidDescriptionProperties)

return Rodux.createReducer({}, {
	[SetHumanoidDescriptionProperties.name] = function(p1, p2) -- line: 10
		-- upvalues: Cryo (copy)
		local tableOfHumanoidDescriptionProperties = p2.tableOfHumanoidDescriptionProperties

		return Cryo.Dictionary.join(p1, tableOfHumanoidDescriptionProperties)
	end
})
