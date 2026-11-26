local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface

local marketplaceSurfaceType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Enums/ImpressionEnums").MarketplaceSurfaceType

local v5 = {
	[marketplaceSurfaceType.HOMEPAGE] = unifiedLoggingSurface.CATALOG,
	[marketplaceSurfaceType.SEARCH] = unifiedLoggingSurface.SEARCH_RESULTS,
	[marketplaceSurfaceType.ITEM_DETAIL] = unifiedLoggingSurface.ITEM_DETAILS,
	[marketplaceSurfaceType.COMMUNITY_PROFILE] = unifiedLoggingSurface.COMMUNITY_PROFILE,
	[marketplaceSurfaceType.USER_PROFILE] = unifiedLoggingSurface.USER_PROFILE,
	[marketplaceSurfaceType.DISCOVERY_HOMEPAGE] = unifiedLoggingSurface.DISCOVERY_HOMEPAGE,
	[marketplaceSurfaceType.DISCOVERY_SEARCH_RESULTS] = unifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS
}

local set = {}

for k, v6 in marketplaceSurfaceType do
	set[v6] = true
end

local set2 = {}

for k, v6 in unifiedLoggingSurface do
	if not set[v6] then
		set2[v6] = true
	end
end

local function mapMarketplaceSurfaceToUnifiedLoggingSurface(p2)
	if p2 == nil then
		return nil
	end

	local v6 = v5[p2]

	if v6 ~= nil then
		return v6
	end

	if set2[p2] then
		return p2
	end

	return nil
end

return mapMarketplaceSurfaceToUnifiedLoggingSurface
