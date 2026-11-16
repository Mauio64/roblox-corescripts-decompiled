local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local AvatarScreenProperties = require(AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties)

local function getActiveAvatarScreen(p)
	if not p then
		return nil
	end

	while p and p.routes do
		local route = p.routes[p.index]

		if route == nil or not AvatarScreenProperties[route.routeName] then
			break
		end

		p = route
	end

	return p
end

return getActiveAvatarScreen
