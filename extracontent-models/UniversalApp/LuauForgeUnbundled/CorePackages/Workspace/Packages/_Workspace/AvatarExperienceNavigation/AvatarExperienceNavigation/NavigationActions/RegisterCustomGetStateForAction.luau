require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/Navigation")

local AvatarRootNavigationAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/AvatarRootNavigationAction")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/CustomGetStateForAction")

local function RegisterCustomGetStateForAction(p2, p3)
	return {
		type = AvatarRootNavigationAction.RegisterCustomGetStateForAction,
		handlerId = p2,
		handler = p3
	}
end

return RegisterCustomGetStateForAction
