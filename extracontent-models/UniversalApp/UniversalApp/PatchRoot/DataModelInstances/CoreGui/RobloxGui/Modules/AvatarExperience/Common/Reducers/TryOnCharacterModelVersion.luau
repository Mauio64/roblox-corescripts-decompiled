local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local IncrementTryOnCharacterModelVersion = require(Modules.AvatarExperience.Catalog.Actions.IncrementTryOnCharacterModelVersion)

return Rodux.createReducer(0, {
	[IncrementTryOnCharacterModelVersion.name] = function(p1, _) -- line: 12
		return p1 + 1
	end
})
