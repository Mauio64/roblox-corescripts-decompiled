local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local parent = AvatarExperienceRodux.Parent
local Rodux = require(parent.Rodux)

local PlayingSwimAnimation = require(AvatarExperienceRodux.Actions.PlayingSwimAnimation)

return Rodux.createReducer(false, {
	[PlayingSwimAnimation.name] = function(_: boolean, p)
		return p.playingSwimAnimation
	end
})
