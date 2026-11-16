local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties

local function getUnifiedLoggingSurfaceForAppPage(value)
	if typeof(value) ~= "string" or value == "" then
		return nil
	end

	local avatarScreenProperty = avatarScreenProperties[value]

	if avatarScreenProperty and avatarScreenProperty.analyticsData then
		return avatarScreenProperty.analyticsData.unifiedLoggingSurface
	end

	return nil
end

return getUnifiedLoggingSurfaceForAppPage
