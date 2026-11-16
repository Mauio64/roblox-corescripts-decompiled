local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local function getUnifiedLoggingSurface(p)
	local v

	if p and p.opaque then
		v = AvatarScreenProperties[p.opaque.name]
	end

	local unifiedLoggingSurface

	if v and v.analyticsData then
		unifiedLoggingSurface = v.analyticsData.unifiedLoggingSurface
	end

	if unifiedLoggingSurface then
		return unifiedLoggingSurface
	end

	if FFlagAXUnifiedEventStrictPayloads then
		return UnifiedLoggingSurface.UNDEFINED_SURFACE
	end

	unifiedLoggingSurface = nil
	return unifiedLoggingSurface
end

return getUnifiedLoggingSurface
