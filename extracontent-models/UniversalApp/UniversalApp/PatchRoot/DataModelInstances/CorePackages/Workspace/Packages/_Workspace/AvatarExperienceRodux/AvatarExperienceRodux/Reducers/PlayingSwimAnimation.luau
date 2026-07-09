local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local AvatarExperienceRoduxParent = AvatarExperienceRodux.Parent
local Rodux = require(AvatarExperienceRoduxParent.Rodux)
local PlayingSwimAnimation = require(AvatarExperienceRodux.Actions.PlayingSwimAnimation)

return Rodux.createReducer(false, {
	[PlayingSwimAnimation.name] = function(_: boolean, p1) -- line: 10
		return p1.playingSwimAnimation
	end
})
