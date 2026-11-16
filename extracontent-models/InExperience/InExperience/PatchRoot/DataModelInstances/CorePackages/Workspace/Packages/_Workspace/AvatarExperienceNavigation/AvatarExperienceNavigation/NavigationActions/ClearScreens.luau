local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")

local AvatarMainStackNavigationAction = require(AvatarExperienceNavigation.Enums.AvatarMainStackNavigationAction)

local function ClearScreens(routeNames)
	return { type = AvatarMainStackNavigationAction.ClearScreens, routeNames = routeNames }
end

return ClearScreens
