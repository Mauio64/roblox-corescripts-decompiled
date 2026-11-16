local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")

local UnifiedEventLogEnums = require(AvatarExperienceAnalytics.UnifiedEventLogEnums)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)

local function getMarketplaceUnifiedLookType(p: string?)
	if p == nil then
		return nil
	end

	return UnifiedEventLogEnums.MarketplaceLookType[UnifiedEventLoggingUtils.formatLookTypeAttribute(p)]
end

return getMarketplaceUnifiedLookType
