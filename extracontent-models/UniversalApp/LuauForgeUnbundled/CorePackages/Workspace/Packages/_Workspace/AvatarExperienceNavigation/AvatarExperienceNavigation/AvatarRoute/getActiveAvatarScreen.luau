local AvatarScreenProperties = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/AvatarScreenProperties")

local function getActiveAvatarScreen(p2)
	if not p2 then
		return nil
	end

	while p2 and p2.routes do
		local route = p2.routes[p2.index]

		if route == nil or not AvatarScreenProperties[route.routeName] then
			break
		end

		p2 = route
	end

	return p2
end

return getActiveAvatarScreen
