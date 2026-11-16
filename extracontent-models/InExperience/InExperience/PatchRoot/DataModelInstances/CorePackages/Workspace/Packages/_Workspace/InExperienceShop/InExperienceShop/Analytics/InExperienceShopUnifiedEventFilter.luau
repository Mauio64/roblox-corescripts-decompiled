local parent = script:FindFirstAncestor("InExperienceShop").Parent

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)

local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local MarketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local MarketplaceUnifiedItemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType

local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local InExperienceShopUnifiedEventFilter = {}

local set = {
	[UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_HOME] = true,
	[UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_DETAILS] = true,
	[UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_SEARCH] = true
}

local set2 = {
	[MarketplaceUnifiedItemType.GAME_PASS] = true,
	[MarketplaceUnifiedItemType.DEVELOPER_PRODUCT] = true,
	[MarketplaceUnifiedItemType.ROBUX] = true,
	[MarketplaceUnifiedItemType.ROBUX_WITH_BONUS] = true
}

function InExperienceShopUnifiedEventFilter.hasItemId(p): boolean
	local itemId = p.itemId
	return itemId ~= nil and itemId ~= ""
end

function InExperienceShopUnifiedEventFilter.hasValidItemType(p): boolean
	local itemType = p.itemType
	return itemType ~= nil and set2[itemType] == true
end

function InExperienceShopUnifiedEventFilter.hasValidAction(p): boolean
	local action = p.action
	return action ~= nil and action ~= MarketplaceUnifiedAction.UNDEFINED_ACTION
end

function InExperienceShopUnifiedEventFilter.hasValidSurface(p): boolean
	local surface = p.surface
	return surface ~= nil and set[surface] == true
end

function InExperienceShopUnifiedEventFilter.hasValidSizeAndPosition(data): boolean
	local action = data.action

	if
		action ~= MarketplaceUnifiedAction.ITEM_IMPRESSION
		and action ~= MarketplaceUnifiedAction.ITEM_SELECTED
		and action ~= MarketplaceUnifiedAction.ITEM_DESELECTED
		and action ~= MarketplaceUnifiedAction.PURCHASE_SUCCESS
	then
		return true
	end

	local screenSizeWidth = data.screenSizeWidth or 0
	local screenSizeHeight = data.screenSizeHeight or 0
	local elementSizeWidth = data.elementSizeWidth or 0
	local elementSizeHeight = data.elementSizeHeight or 0
	local gridPositionRow = data.gridPositionRow or 0
	local gridPositionColumn = data.gridPositionColumn or 0

	return screenSizeWidth > 0
		and screenSizeHeight > 0
		and elementSizeWidth > 0
		and elementSizeHeight > 0
		and gridPositionRow > 0
		and gridPositionColumn > 0
end

function InExperienceShopUnifiedEventFilter.hasUniverseId(p): boolean
	local universeId = p.universeId

	if typeof(universeId) == "number" then
		return universeId > 0
	end

	return typeof(universeId) == "string" and universeId ~= ""
end

function InExperienceShopUnifiedEventFilter.filter(p)
	local itemId = InExperienceShopUnifiedEventFilter.hasItemId(p)
	local validItemType = InExperienceShopUnifiedEventFilter.hasValidItemType(p)
	local validAction = InExperienceShopUnifiedEventFilter.hasValidAction(p)
	local validSurface = InExperienceShopUnifiedEventFilter.hasValidSurface(p)
	local validSizeAndPosition = InExperienceShopUnifiedEventFilter.hasValidSizeAndPosition(p)
	local universeId = InExperienceShopUnifiedEventFilter.hasUniverseId(p)
	local v = itemId and validItemType and validAction and validSurface and validSizeAndPosition and universeId

	if v then
		return v
	end

	local v2 = ""

	if not itemId then
		v2 ..= "hasItemId "
	end

	if not validItemType then
		v2 ..= "hasValidItemType "
	end

	if not validAction then
		v2 ..= "hasValidAction "
	end

	if not validSurface then
		v2 ..= "hasValidSurface "
	end

	if not validSizeAndPosition then
		v2 ..= "hasValidSizeAndPosition "
	end

	if not universeId then
		v2 ..= "hasUniverseId "
	end

	warn("Failed to send in-experience shop unified event. Failing Check(s): " .. v2)

	return v
end

return InExperienceShopUnifiedEventFilter
