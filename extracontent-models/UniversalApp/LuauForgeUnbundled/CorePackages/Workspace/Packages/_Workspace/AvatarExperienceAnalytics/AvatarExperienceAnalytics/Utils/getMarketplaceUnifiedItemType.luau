require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceModel")
local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")

local function getMarketplaceUnifiedItemType(p2)
	if p2 == "Look" then
		return UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
	elseif p2 == "Asset" then
		return UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
	elseif p2 == "Bundle" then
		return UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
	end

	return nil
end

return getMarketplaceUnifiedItemType
