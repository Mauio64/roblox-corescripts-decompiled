local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local AvatarMainStackNavigationAction = require(AvatarExperienceNavigation.Enums.AvatarMainStackNavigationAction)

local function ClearScreens(t1: {[any]: any}) -- line: 5
	-- upvalues: AvatarMainStackNavigationAction (copy)
	return {
		type = AvatarMainStackNavigationAction.ClearScreens,
		routeNames = t1
	}
end

return ClearScreens
