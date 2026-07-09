local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local IncrementCharacterVersion = require(Modules.AvatarExperience.Common.Actions.IncrementCharacterVersion)

return Rodux.createReducer(0, {
	[IncrementCharacterVersion.name] = function(n1: number, _) -- line: 37
		return n1 + 1
	end
})
