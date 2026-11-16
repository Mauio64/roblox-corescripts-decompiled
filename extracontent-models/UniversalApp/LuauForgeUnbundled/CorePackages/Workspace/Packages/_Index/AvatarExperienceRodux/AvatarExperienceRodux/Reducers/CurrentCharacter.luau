local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")

local SetCurrentCharacter = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetCurrentCharacter")

return Rodux.createReducer(nil, {
	[SetCurrentCharacter.name] = function(p2, p3)
		return p3.currentCharacter
	end
})
