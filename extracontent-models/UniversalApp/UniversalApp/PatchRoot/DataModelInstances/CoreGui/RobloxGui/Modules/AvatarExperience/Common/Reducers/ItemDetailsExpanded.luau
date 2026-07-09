local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local SetItemDetailsExpanded = require(Modules.AvatarExperience.Common.Actions.SetItemDetailsExpanded)

return Rodux.createReducer(false, {
	[SetItemDetailsExpanded.name] = function(_, p2) -- line: 12
		return p2.itemDetailsExpanded
	end
})
