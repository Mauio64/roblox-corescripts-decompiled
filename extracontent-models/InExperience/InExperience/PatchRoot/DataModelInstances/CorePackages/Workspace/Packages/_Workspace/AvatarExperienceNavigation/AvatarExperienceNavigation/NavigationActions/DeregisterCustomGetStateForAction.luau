local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")

local AvatarRootNavigationAction = require(AvatarExperienceNavigation.Enums.AvatarRootNavigationAction)
require(AvatarExperienceNavigation.Enums.CustomGetStateForAction)

local function DeregisterCustomGetStateForAction(handlerId)
	return {
		type = AvatarRootNavigationAction.DeregisterCustomGetStateForAction,
		handlerId = handlerId
	}
end

return DeregisterCustomGetStateForAction
