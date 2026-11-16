local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation")
local avatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local function getUnifiedLoggingSurface(p2)
	local v5 = if p2 and p2.opaque then avatarScreenProperties[p2.opaque.name] else nil

	local unifiedLoggingSurface2 = if v5 and v5.analyticsData then v5.analyticsData.unifiedLoggingSurface else nil

	if unifiedLoggingSurface2 then
		return unifiedLoggingSurface2
	end

	if fFlagAXUnifiedEventStrictPayloads then
		return unifiedLoggingSurface.UNDEFINED_SURFACE
	end

	unifiedLoggingSurface2 = nil
	return unifiedLoggingSurface2
end

return getUnifiedLoggingSurface
