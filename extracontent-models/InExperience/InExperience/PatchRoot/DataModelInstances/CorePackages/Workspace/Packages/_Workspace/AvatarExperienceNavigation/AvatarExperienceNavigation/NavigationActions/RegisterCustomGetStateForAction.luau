local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")

local parent = AvatarExperienceNavigation.Parent
require(parent.Navigation)

local AvatarRootNavigationAction = require(AvatarExperienceNavigation.Enums.AvatarRootNavigationAction)
require(AvatarExperienceNavigation.Enums.CustomGetStateForAction)

local function RegisterCustomGetStateForAction(handlerId, handler)
	return {
		type = AvatarRootNavigationAction.RegisterCustomGetStateForAction,
		handlerId = handlerId,
		handler = handler
	}
end

return RegisterCustomGetStateForAction
