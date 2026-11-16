local marketplaceUnifiedAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums").MarketplaceUnifiedAction

local function getItemSelectionAction(p2)
	if p2 then
		return marketplaceUnifiedAction.ITEM_DESELECTED
	end

	return marketplaceUnifiedAction.ITEM_SELECTED
end

return getItemSelectionAction
