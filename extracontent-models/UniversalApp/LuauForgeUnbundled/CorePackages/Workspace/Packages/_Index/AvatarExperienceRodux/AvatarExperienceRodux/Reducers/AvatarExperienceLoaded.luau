local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")

local AvatarExperienceLoaded = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/AvatarExperienceLoaded")

return Rodux.createReducer(false, {
	[AvatarExperienceLoaded.name] = function(p2, p3): boolean
		return true
	end
})
