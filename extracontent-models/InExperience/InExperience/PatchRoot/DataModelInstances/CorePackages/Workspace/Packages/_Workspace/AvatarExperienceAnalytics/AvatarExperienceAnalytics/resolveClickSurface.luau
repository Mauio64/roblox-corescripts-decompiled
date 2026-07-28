local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local AvatarScreenProperties = require(Parent.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties

local function resolveClickSurface(p1, p2) -- line: 10
	-- upvalues: UnifiedEventLogConstants (copy), AvatarScreenProperties (copy)
	if p1:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface") ~= nil then
		return nil
	end

	if not p2 or not p2.current or not p2.opaque then
		return nil
	end

	local v7 = AvatarScreenProperties[p2.opaque.name]

	if v7 and v7.analyticsData then
		return v7.analyticsData.unifiedLoggingSurface
	end

	return nil
end

return resolveClickSurface
