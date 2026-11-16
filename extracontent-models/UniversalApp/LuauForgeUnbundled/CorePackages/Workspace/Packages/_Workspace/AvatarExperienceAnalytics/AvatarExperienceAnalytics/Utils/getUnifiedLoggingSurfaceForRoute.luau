local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation")
local avatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local getUnifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getUnifiedLoggingSurface")

local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local function getUnifiedLoggingSurfaceForRoute(p2)
	if p2 == nil then
		if fFlagAXUnifiedEventStrictPayloads then
			return unifiedLoggingSurface.UNDEFINED_SURFACE
		end

		return nil
	else
		local name = if p2.current then p2.current.name else nil
		local v5 = if name then avatarScreenProperties[name] else nil
		local unifiedLoggingSurface2 = if v5 and v5.analyticsData then v5.analyticsData.unifiedLoggingSurface else nil

		if v5 and v5.isTransparent and unifiedLoggingSurface2 ~= nil then
			return unifiedLoggingSurface2
		end

		if not fFlagAXUnifiedEventStrictPayloads then
			return getUnifiedLoggingSurface(p2) or unifiedLoggingSurface2
		end

		local v6 = getUnifiedLoggingSurface(p2)

		if v6 ~= unifiedLoggingSurface.UNDEFINED_SURFACE then
			return v6
		end

		if unifiedLoggingSurface2 == nil then
			return unifiedLoggingSurface.UNDEFINED_SURFACE
		end

		return unifiedLoggingSurface2
	end
end

return getUnifiedLoggingSurfaceForRoute
