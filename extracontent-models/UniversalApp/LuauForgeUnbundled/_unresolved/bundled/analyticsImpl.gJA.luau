local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums

local function analyticsImpl(object, value, value2, value3, value4, value5, p2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected propertyName to be a string")
	assert(type(value3) == "string" or type(value3) == "number", "Expected propertyValue to be a string")
	assert(type(value4) == "number", "Expected currentCategoryIndex to be a number")
	assert(type(value5) == "number", "Expected tabIndex to be a number")

	local v5 = nil

	if value == "EquipAsset" then
		v5 = impressionEnums.ActionType.ITEM_CLICK
	elseif value == "UnequipAsset" then
		v5 = impressionEnums.ActionType.ITEM_DESELECTED
	end

	object:sendTelemetryEvent(value, "marketplaceOrganicFELog", {
		requestId = p2,
		itemId = value3,
		actionType = v5,
		surface = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
	})
end

return analyticsImpl
