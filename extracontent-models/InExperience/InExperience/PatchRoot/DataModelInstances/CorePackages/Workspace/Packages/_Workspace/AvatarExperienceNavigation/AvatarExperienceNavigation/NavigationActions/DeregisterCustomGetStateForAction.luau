local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local AvatarRootNavigationAction = require(AvatarExperienceNavigation.Enums.AvatarRootNavigationAction)

require(AvatarExperienceNavigation.Enums.CustomGetStateForAction)

local function DeregisterCustomGetStateForAction(p1) -- line: 6
	-- upvalues: AvatarRootNavigationAction (copy)
	return {
		type = AvatarRootNavigationAction.DeregisterCustomGetStateForAction,
		handlerId = p1
	}
end

return DeregisterCustomGetStateForAction
