local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local UnifiedEventLogEnums = require(AvatarExperienceAnalytics.UnifiedEventLogEnums)

local function getItemSelectionAction(b1: boolean) -- line: 5
	-- upvalues: UnifiedEventLogEnums (copy)
	if b1 then
		return UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED
	end

	return UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED
end

return getItemSelectionAction
