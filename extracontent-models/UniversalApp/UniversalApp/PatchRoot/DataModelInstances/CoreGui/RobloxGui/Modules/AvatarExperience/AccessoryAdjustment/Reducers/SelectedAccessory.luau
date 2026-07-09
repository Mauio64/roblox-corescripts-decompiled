local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Modules = CoreGui.RobloxGui.Modules
local SetSelectedAccessory = require(Modules.AvatarExperience.AccessoryAdjustment.Actions.SetSelectedAccessory)

return Rodux.createReducer(nil, {
	[SetSelectedAccessory.name] = function(_, p2) -- line: 18
		return p2.selectedAccessory
	end
})
