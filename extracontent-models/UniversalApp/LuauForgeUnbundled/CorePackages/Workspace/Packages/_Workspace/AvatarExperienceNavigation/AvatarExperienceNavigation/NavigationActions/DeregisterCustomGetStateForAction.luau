local AvatarRootNavigationAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/AvatarRootNavigationAction")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/CustomGetStateForAction")

local function DeregisterCustomGetStateForAction(p2)
	return { type = AvatarRootNavigationAction.DeregisterCustomGetStateForAction, handlerId = p2 }
end

return DeregisterCustomGetStateForAction
