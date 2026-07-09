local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local IncrementSavedCharacterModelVersion = require(Modules.AvatarExperience.Common.Actions.IncrementSavedCharacterModelVersion)

return Rodux.createReducer(0, {
	[IncrementSavedCharacterModelVersion.name] = function(p1, _) -- line: 12
		return p1 + 1
	end
})
