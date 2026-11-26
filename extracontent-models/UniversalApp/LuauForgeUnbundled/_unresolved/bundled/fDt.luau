local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface
local contexts = require("@luauforge/bundled/ecs").Analytics.Enums.Contexts

local marketplaceUnifiedAction = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedAction
local getMarketplaceUnifiedItemType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedItemType

return function(callback, p2, itemId, p3, itemPosition)
	local v5 = {
		action = marketplaceUnifiedAction.ITEM_SELECTED,
		surface = 0,
		itemId = 0,
		itemType = 0,
		itemPosition = 0
	}
	local v6 = if p2 == contexts.CommunityProfile then unifiedLoggingSurface.COMMUNITY_PROFILE else unifiedLoggingSurface.USER_PROFILE
	v5.surface = v6

	v5.itemId = itemId
	v5.itemType = getMarketplaceUnifiedItemType(p3)
	v5.itemPosition = itemPosition
	callback(v5)
end
