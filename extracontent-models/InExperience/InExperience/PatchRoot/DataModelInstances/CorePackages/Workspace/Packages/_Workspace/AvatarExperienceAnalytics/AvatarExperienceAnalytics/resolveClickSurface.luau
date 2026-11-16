local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties

local function resolveClickSurface(instance, p)
	if not (instance:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface") == nil and (p and p.current and p.opaque)) then
		return nil
	end

	local avatarScreenProperty = AvatarScreenProperties[p.opaque.name]

	if avatarScreenProperty and avatarScreenProperty.analyticsData then
		return avatarScreenProperty.analyticsData.unifiedLoggingSurface
	end

	return nil
end

return resolveClickSurface
