local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")

local SetAvatarSceneRoute = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetAvatarSceneRoute")
local avatarRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceNavigation").AvatarRoute.AvatarRoute.new({})

return Rodux.createReducer(avatarRoute, {
	[SetAvatarSceneRoute.name] = function(p2, p3)
		return p3.avatarRoute
	end
})
