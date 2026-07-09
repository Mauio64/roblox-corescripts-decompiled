local CorePackages = game:GetService("CorePackages")
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums

local function analyticsImpl(p1, p2, p3, p4, p5, p6, p7) -- line: 9
	-- upvalues: ImpressionEnums (copy)
	assert(type(p2) == "string", "Expected eventContext to be a string")
	assert(type(p3) == "string", "Expected propertyName to be a string")
	assert(type(p4) == "string" or type(p4) == "number", "Expected propertyValue to be a string")
	assert(type(p5) == "number", "Expected currentCategoryIndex to be a number")
	assert(type(p6) == "number", "Expected tabIndex to be a number")

	local ITEM_CLICK = nil

	if p2 == "EquipAsset" then
		ITEM_CLICK = ImpressionEnums.ActionType.ITEM_CLICK
	elseif p2 == "UnequipAsset" then
		ITEM_CLICK = ImpressionEnums.ActionType.ITEM_DESELECTED
	end

	p1:sendTelemetryEvent(p2, "marketplaceOrganicFELog", {
		requestId = p7,
		itemId = p4,
		actionType = ITEM_CLICK,
		surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
	})
end

return analyticsImpl
