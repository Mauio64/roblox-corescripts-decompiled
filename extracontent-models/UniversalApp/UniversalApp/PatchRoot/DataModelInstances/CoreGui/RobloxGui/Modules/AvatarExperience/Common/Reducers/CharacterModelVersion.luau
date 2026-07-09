local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local IncrementCharacterModelVersion = require(Modules.AvatarExperience.AvatarEditor.Actions.IncrementCharacterModelVersion)

return Rodux.createReducer(0, {
	[IncrementCharacterModelVersion.name] = function(p1, _) -- line: 12
		return p1 + 1
	end
})
