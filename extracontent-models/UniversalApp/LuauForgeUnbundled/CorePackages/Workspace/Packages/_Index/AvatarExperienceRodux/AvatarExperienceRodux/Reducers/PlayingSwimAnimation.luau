local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")

local PlayingSwimAnimation = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/PlayingSwimAnimation")

return Rodux.createReducer(false, {
	[PlayingSwimAnimation.name] = function(p2, p3)
		return p3.playingSwimAnimation
	end
})
