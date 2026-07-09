local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local SetPageLoaded = require(Modules.AvatarExperience.AvatarEditor.Actions.SetPageLoaded)

return Rodux.createReducer(false, {
	[SetPageLoaded.name] = function(_, p2) -- line: 13
		return p2.value
	end
})
