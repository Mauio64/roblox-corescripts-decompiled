local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")

local UnifiedEventLogEnums = require(AvatarExperienceAnalytics.UnifiedEventLogEnums)
local MarketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction

local function getItemSelectionAction(flag: boolean)
	if flag then
		return MarketplaceUnifiedAction.ITEM_DESELECTED
	end

	return MarketplaceUnifiedAction.ITEM_SELECTED
end

return getItemSelectionAction
