local AvatarMainStackNavigationAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/AvatarMainStackNavigationAction")

local function ClearScreens(p2)
	return { type = AvatarMainStackNavigationAction.ClearScreens, routeNames = p2 }
end

return ClearScreens
