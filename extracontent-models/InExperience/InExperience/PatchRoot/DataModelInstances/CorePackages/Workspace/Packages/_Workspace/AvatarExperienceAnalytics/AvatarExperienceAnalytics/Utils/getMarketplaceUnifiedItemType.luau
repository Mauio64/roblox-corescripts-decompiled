local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local parent = AvatarExperienceAnalytics.Parent

require(parent.AvatarExperienceModel)
local UnifiedEventLogEnums = require(AvatarExperienceAnalytics.UnifiedEventLogEnums)

local function getMarketplaceUnifiedItemType(p)
	if p == "Look" then
		return UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
	elseif p == "Asset" then
		return UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
	elseif p == "Bundle" then
		return UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
	end

	return nil
end

return getMarketplaceUnifiedItemType
