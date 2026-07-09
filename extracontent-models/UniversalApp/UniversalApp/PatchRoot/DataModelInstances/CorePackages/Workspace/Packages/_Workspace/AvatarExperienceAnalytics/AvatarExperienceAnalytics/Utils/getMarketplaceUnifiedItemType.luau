local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent

require(AvatarExperienceAnalyticsParent.AvatarExperienceCommon)

local UnifiedEventLogEnums = require(AvatarExperienceAnalytics.UnifiedEventLogEnums)

local function getMarketplaceUnifiedItemType(p1) -- line: 13
	-- upvalues: UnifiedEventLogEnums (copy)
	if p1 == "Look" then
		return UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
	end

	if p1 == "Asset" then
		return UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
	end

	if p1 == "Bundle" then
		return UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
	end

	return nil
end

return getMarketplaceUnifiedItemType
