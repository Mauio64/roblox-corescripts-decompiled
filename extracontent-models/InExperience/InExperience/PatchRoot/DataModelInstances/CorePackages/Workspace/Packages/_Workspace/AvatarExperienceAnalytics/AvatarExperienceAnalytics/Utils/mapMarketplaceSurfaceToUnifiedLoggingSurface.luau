local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local parent = AvatarExperienceAnalytics.Parent

local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local ImpressionEnums = require(AvatarExperienceAnalytics.Enums.ImpressionEnums)
local MarketplaceSurfaceType = ImpressionEnums.MarketplaceSurfaceType

local v = {
	[MarketplaceSurfaceType.HOMEPAGE] = UnifiedLoggingSurface.CATALOG,
	[MarketplaceSurfaceType.SEARCH] = UnifiedLoggingSurface.SEARCH_RESULTS,
	[MarketplaceSurfaceType.ITEM_DETAIL] = UnifiedLoggingSurface.ITEM_DETAILS,
	[MarketplaceSurfaceType.COMMUNITY_PROFILE] = UnifiedLoggingSurface.COMMUNITY_PROFILE,
	[MarketplaceSurfaceType.USER_PROFILE] = UnifiedLoggingSurface.USER_PROFILE,
	[MarketplaceSurfaceType.DISCOVERY_HOMEPAGE] = UnifiedLoggingSurface.DISCOVERY_HOMEPAGE,
	[MarketplaceSurfaceType.DISCOVERY_SEARCH_RESULTS] = UnifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS
}

local set = {}

for _, v2 in MarketplaceSurfaceType do
	set[v2] = true
end

local set2 = {}

for _, v2 in UnifiedLoggingSurface do
	if not set[v2] then
		set2[v2] = true
	end
end

local function mapMarketplaceSurfaceToUnifiedLoggingSurface(p: number?)
	if p == nil then
		return nil
	end

	local v2 = v[p]

	if v2 ~= nil then
		return v2
	end

	return if set2[p] then p else nil
end

return mapMarketplaceSurfaceToUnifiedLoggingSurface
