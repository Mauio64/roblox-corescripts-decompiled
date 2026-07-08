local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local AvatarScreenProperties = require(Parent.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties

local function getUnifiedLoggingSurfaceForAppPage(s1: string?) -- line: 21
	-- upvalues: AvatarScreenProperties (copy)
	if typeof(s1) ~= "string" or s1 == "" then
		return nil
	end

	local v5 = AvatarScreenProperties[s1]

	if v5 and v5.analyticsData then
		return v5.analyticsData.unifiedLoggingSurface
	end

	return nil
end

return getUnifiedLoggingSurfaceForAppPage
