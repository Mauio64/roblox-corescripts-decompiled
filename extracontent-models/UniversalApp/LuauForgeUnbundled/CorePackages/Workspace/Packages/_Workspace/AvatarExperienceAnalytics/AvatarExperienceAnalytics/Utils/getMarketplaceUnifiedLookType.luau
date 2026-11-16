local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")
local UnifiedEventLoggingUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/UnifiedEventLoggingUtils")

local function getMarketplaceUnifiedLookType(p2)
	if p2 == nil then
		return nil
	end

	return UnifiedEventLogEnums.MarketplaceLookType[UnifiedEventLoggingUtils.formatLookTypeAttribute(p2)]
end

return getMarketplaceUnifiedLookType
