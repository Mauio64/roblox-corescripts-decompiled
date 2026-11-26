local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")
local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties

local function resolveClickSurface(instance, p2)
	if not (instance:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface") == nil and (p2 and p2.current and p2.opaque)) then
		return nil
	end

	local avatarScreenProperty = avatarScreenProperties[p2.opaque.name]

	if avatarScreenProperty and avatarScreenProperty.analyticsData then
		return avatarScreenProperty.analyticsData.unifiedLoggingSurface
	end

	return nil
end

return resolveClickSurface
