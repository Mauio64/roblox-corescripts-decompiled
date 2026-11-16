local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties

local function getUnifiedLoggingSurfaceForAppPage(value: string?)
	if typeof(value) ~= "string" or value == "" then
		return nil
	end

	local avatarScreenProperty = AvatarScreenProperties[value]

	if avatarScreenProperty and avatarScreenProperty.analyticsData then
		return avatarScreenProperty.analyticsData.unifiedLoggingSurface
	end

	return nil
end

return getUnifiedLoggingSurfaceForAppPage
