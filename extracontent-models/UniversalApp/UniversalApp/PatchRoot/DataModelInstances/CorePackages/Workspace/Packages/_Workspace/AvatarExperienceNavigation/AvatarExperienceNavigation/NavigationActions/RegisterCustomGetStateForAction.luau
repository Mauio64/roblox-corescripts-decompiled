local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local AvatarExperienceNavigationParent = AvatarExperienceNavigation.Parent

require(AvatarExperienceNavigationParent.Navigation)

local AvatarRootNavigationAction = require(AvatarExperienceNavigation.Enums.AvatarRootNavigationAction)

require(AvatarExperienceNavigation.Enums.CustomGetStateForAction)

local function RegisterCustomGetStateForAction(p1, p2: ((...any) -> ...any)) -- line: 14
	-- upvalues: AvatarRootNavigationAction (copy)
	return {
		type = AvatarRootNavigationAction.RegisterCustomGetStateForAction,
		handlerId = p1,
		handler = p2
	}
end

return RegisterCustomGetStateForAction
