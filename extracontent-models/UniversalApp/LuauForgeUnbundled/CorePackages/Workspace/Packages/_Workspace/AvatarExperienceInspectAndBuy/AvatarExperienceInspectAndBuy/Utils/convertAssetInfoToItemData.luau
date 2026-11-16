require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/tutils")
local itemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local fFlagAXMarketplaceLicensingItemCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceFlags").FFlagAXMarketplaceLicensingItemCards

return function(data, p2)
	local v5 = not p2 and 0 or tutils.fieldCount(p2)

	local v6 = {
		id = data.assetId,
		name = data.name,
		meta = data.meta,
		description = data.description,
		itemType = itemTypeEnum.Asset,
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

	local v7 = if fFlagAXMarketplaceLicensingItemCards then data.itemLicensingInfo else nil
	v6.itemLicensingInfo = v7
	v6.saleLocationType = data.saleLocationType
	v6.itemRestrictions = data.itemRestrictions or {}
	v6.priceInRobux = data.price
	v6.noPriceStatus = data.noPriceStatus
	v6.catalogPriceStatus = data.catalogPriceStatus
	v6.isOwned = data.owned
	v6.isOffSale = data.isOffSale
	v6.collectibleItemId = data.collectibleItemId
	v6.creatingUniverseId = data.creatingUniverseId
	v6.collectibleItemDetails = {
		quantityLimitPerUser = data.collectibleQuantityLimitPerUser,
		resellableCount = data.resellableCount or v5,
		collectibleLowestAvailableResaleProductId = data.collectibleLowestAvailableResaleProductId,
		collectibleLowestAvailableResaleItemInstanceId = data.collectibleLowestAvailableResaleItemInstanceId,
		unitsAvailableForConsumption = data.remaining,
		hasResellers = data.hasResellers or data.collectibleLowestAvailableResaleProductId ~= nil and data.collectibleLowestAvailableResaleProductId ~= "",
		lowestResalePrice = data.collectibleLowestResalePrice or 0,
		totalQuantity = data.collectibleTotalQuantity or 0,
		experiences = data and data.saleLocation and data.saleLocation.UniverseIds or {}
	}

	v6.favoritesDetails = {
		numFavorites = data.numFavorites,
		isFavorited = data.isFavorited
	}

	v6.timedOptions = data.timedOptions
	return v6
end
