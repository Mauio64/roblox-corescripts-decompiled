local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local getUnifiedLoggingSurface = require(script.Parent.getUnifiedLoggingSurface)

local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local function getUnifiedLoggingSurfaceForRoute(p)
	if p == nil then
		if FFlagAXUnifiedEventStrictPayloads then
			return UnifiedLoggingSurface.UNDEFINED_SURFACE
		end

		return nil
	else
		local name

		if p.current then
			name = p.current.name
		end

		local v

		if name then
			v = AvatarScreenProperties[name]
		end

		local unifiedLoggingSurface

		if v and v.analyticsData then
			unifiedLoggingSurface = v.analyticsData.unifiedLoggingSurface
		end

		if v and v.isTransparent and unifiedLoggingSurface ~= nil then
			return unifiedLoggingSurface
		end

		if not FFlagAXUnifiedEventStrictPayloads then
			return getUnifiedLoggingSurface(p) or unifiedLoggingSurface
		end

		local unifiedLoggingSurface2 = getUnifiedLoggingSurface(p)

		if unifiedLoggingSurface2 ~= UnifiedLoggingSurface.UNDEFINED_SURFACE then
			return unifiedLoggingSurface2
		end

		if unifiedLoggingSurface == nil then
			return UnifiedLoggingSurface.UNDEFINED_SURFACE
		end

		return unifiedLoggingSurface
	end
end

return getUnifiedLoggingSurfaceForRoute
