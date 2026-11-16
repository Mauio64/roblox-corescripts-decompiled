local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
require(AvatarExperienceInspectAndBuy.Types)
local AvatarExperienceModel = require(AvatarExperienceInspectAndBuy.Parent.AvatarExperienceModel)
local tutils = require(parent.tutils)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards

return function(data, p)
	local v = not p and 0 or tutils.fieldCount(p)

	local v2 = {
		id = data.assetId,
		name = data.name,
		meta = data.meta,
		description = data.description,
		itemType = ItemTypeEnum.Asset,
		itemSubType = data.assetTypeId,
		creator = {
			creatorId = data.creatorId or "",
			creatorName = data.creatorName or "",
			creatorHasVerifiedBadge = data.creatorHasVerifiedBadge or false
		},
		itemLicensingInfo = 0,
		saleLocationType = 0,
		itemRestrictions = 0,
		priceInRobux = 0,
		noPriceStatus = 0,
		catalogPriceStatus = 0,
		isOwned = 0,
		isOffSale = 0,
		collectibleItemId = 0,
		creatingUniverseId = 0,
		collectibleItemDetails = 0,
		favoritesDetails = 0,
		timedOptions = 0
	}
	local itemLicensingInfo

	if FFlagAXMarketplaceLicensingItemCards then
		itemLicensingInfo = data.itemLicensingInfo
	end

	v2.itemLicensingInfo = itemLicensingInfo
	v2.saleLocationType = data.saleLocationType
	v2.itemRestrictions = data.itemRestrictions or {}
	v2.priceInRobux = data.price
	v2.noPriceStatus = data.noPriceStatus
	v2.catalogPriceStatus = data.catalogPriceStatus
	v2.isOwned = data.owned
	v2.isOffSale = data.isOffSale
	v2.collectibleItemId = data.collectibleItemId
	v2.creatingUniverseId = data.creatingUniverseId
	v2.collectibleItemDetails = {
		quantityLimitPerUser = data.collectibleQuantityLimitPerUser,
		resellableCount = data.resellableCount or v,
		collectibleLowestAvailableResaleProductId = data.collectibleLowestAvailableResaleProductId,
		collectibleLowestAvailableResaleItemInstanceId = data.collectibleLowestAvailableResaleItemInstanceId,
		unitsAvailableForConsumption = data.remaining,
		hasResellers = data.hasResellers or data.collectibleLowestAvailableResaleProductId ~= nil and data.collectibleLowestAvailableResaleProductId ~= "",
		lowestResalePrice = data.collectibleLowestResalePrice or 0,
		totalQuantity = data.collectibleTotalQuantity or 0,
		experiences = data and data.saleLocation and data.saleLocation.UniverseIds or {}
	}

	v2.favoritesDetails = { numFavorites = data.numFavorites, isFavorited = data.isFavorited }

	v2.timedOptions = data.timedOptions
	return v2
end
