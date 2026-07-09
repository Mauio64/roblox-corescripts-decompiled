local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local AvatarScreenProperties = require(Parent.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties

local function getUnifiedLoggingSurface(p1) -- line: 9
	-- upvalues: AvatarScreenProperties (copy)
	local v5 = if not p1 or not p1.opaque then nil else AvatarScreenProperties[p1.opaque.name]

	if v5 and v5.analyticsData then
		return v5.analyticsData.unifiedLoggingSurface
	end

	return nil
end

return getUnifiedLoggingSurface
