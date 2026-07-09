local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local LockCharacterUpdates = require(Modules.AvatarExperience.LayeredClothingSort.Actions.LockCharacterUpdates)
local UnlockCharacterUpdates = require(Modules.AvatarExperience.LayeredClothingSort.Actions.UnlockCharacterUpdates)

return Rodux.createReducer(false, {
	[LockCharacterUpdates.name] = function(_, _) -- line: 15
		return true
	end,
	[UnlockCharacterUpdates.name] = function(_, _) -- line: 19
		return false
	end
})
