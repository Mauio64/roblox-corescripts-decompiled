local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local AvatarScreenProperties = require(AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties)

local function getActiveAvatarScreen(p1) -- line: 15
	-- upvalues: AvatarScreenProperties (copy)
	if not p1 then
		return nil
	end

	while p1 and p1.routes do
		local v5 = p1.routes[p1.index]

		if v5 == nil or not AvatarScreenProperties[v5.routeName] then
			return p1
		end

		p1 = v5
	end

	return p1
end

return getActiveAvatarScreen
