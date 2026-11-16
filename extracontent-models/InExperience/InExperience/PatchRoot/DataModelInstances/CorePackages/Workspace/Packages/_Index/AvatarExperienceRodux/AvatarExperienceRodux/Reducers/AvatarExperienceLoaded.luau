local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local parent = AvatarExperienceRodux.Parent
local Rodux = require(parent.Rodux)

local AvatarExperienceLoaded = require(AvatarExperienceRodux.Actions.AvatarExperienceLoaded)

return Rodux.createReducer(false, {
	[AvatarExperienceLoaded.name] = function(_: boolean, _): boolean
		return true
	end
})
