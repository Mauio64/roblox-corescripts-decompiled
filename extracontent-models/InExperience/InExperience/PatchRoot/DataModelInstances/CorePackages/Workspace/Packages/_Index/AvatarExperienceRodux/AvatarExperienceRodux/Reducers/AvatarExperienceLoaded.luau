local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local AvatarExperienceRoduxParent = AvatarExperienceRodux.Parent
local Rodux = require(AvatarExperienceRoduxParent.Rodux)
local AvatarExperienceLoaded = require(AvatarExperienceRodux.Actions.AvatarExperienceLoaded)

return Rodux.createReducer(false, {
	[AvatarExperienceLoaded.name] = function(_: boolean, _) -- line: 10
		return true
	end
})
