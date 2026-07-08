local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent

require(AvatarExperienceInspectAndBuy.Types)

local AXCommon = require(AvatarExperienceInspectAndBuy.Parent.AXCommon)
local tutils = require(AvatarExperienceInspectAndBuyParent.tutils)
local ItemTypeEnum = AXCommon.Enums.ItemTypeEnum
local FFlagAXEnableIaBTimedOptionsBulkPurchase = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags).FFlagAXEnableIaBTimedOptionsBulkPurchase

return function(p1, t1: {[any]: any}?) -- line: 22
	-- upvalues: tutils (copy), ItemTypeEnum (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy)
	local n1 = 0

	if t1 then
		n1 = tutils.fieldCount(t1)
	end

	return {
		id = p1.assetId,
		name = p1.name,
		meta = p1.meta,
		description = p1.description,
		itemType = ItemTypeEnum.Asset,
		itemSubType = p1.assetTypeId,
		creator = {
			creatorId = p1.creatorId or "",
			creatorName = p1.creatorName or "",
			creatorHasVerifiedBadge = p1.creatorHasVerifiedBadge or false
		},
		saleLocationType = p1.saleLocationType,
		itemRestrictions = p1.itemRestrictions or {},
		priceInRobux = p1.price,
		noPriceStatus = p1.noPriceStatus,
		catalogPriceStatus = p1.catalogPriceStatus,
		isOwned = p1.owned,
		isOffSale = p1.isOffSale,
		collectibleItemId = p1.collectibleItemId,
		creatingUniverseId = p1.creatingUniverseId,
		collectibleItemDetails = {
			quantityLimitPerUser = p1.collectibleQuantityLimitPerUser,
			resellableCount = p1.resellableCount or n1,
			collectibleLowestAvailableResaleProductId = p1.collectibleLowestAvailableResaleProductId,
			collectibleLowestAvailableResaleItemInstanceId = p1.collectibleLowestAvailableResaleItemInstanceId,
			unitsAvailableForConsumption = p1.remaining,
			hasResellers = p1.hasResellers or p1.collectibleLowestAvailableResaleProductId ~= nil and (p1.collectibleLowestAvailableResaleProductId ~= "" or false),
			lowestResalePrice = p1.collectibleLowestResalePrice or 0,
			totalQuantity = p1.collectibleTotalQuantity or 0,
			experiences = p1 and (not not p1.saleLocation and p1.saleLocation.UniverseIds) or {}
		},
		favoritesDetails = {
			numFavorites = p1.numFavorites,
			isFavorited = p1.isFavorited
		},
		timedOptions = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else p1.timedOptions
	}
end
