require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel").Enums.ItemTypeEnum
local salesLocationType = AvatarExperienceCommon.Enums.SalesLocationType
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/tutils")

local fFlagAXMarketplaceLicensingItemCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceFlags").FFlagAXMarketplaceLicensingItemCards

return function(data, p2)
	local v5 = not p2 and 0 or tutils.fieldCount(p2)

	local v6 = {}

	if data.assetsInBundle then
		for k, v7 in data.assetsInBundle do
			table.insert(v6, {
				id = tostring(v7.id),
				assetType = tostring(v7.assetType),
				isIncluded = v7.isIncluded,
				meta = v7.meta,
				name = v7.name
			})
		end
	end

	local v7 = {
		id = data.bundleId,
		name = data.name,
		description = data.description,
		itemType = itemTypeEnum.Bundle,
		itemSubType = data.bundleType,
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
		hasResellers = 0,
		isOffSale = 0,
		collectibleItemId = 0,
		collectibleItemDetails = 0,
		assetsInBundle = 0,
		favoritesDetails = 0
	}

	local v8 = if fFlagAXMarketplaceLicensingItemCards then data.itemLicensingInfo else nil
	v7.itemLicensingInfo = v8
	v7.saleLocationType = data.saleLocationType or salesLocationType.Invalid
	v7.itemRestrictions = data.itemRestrictions or {}
	v7.priceInRobux = data.price
	v7.noPriceStatus = data.noPriceStatus
	v7.catalogPriceStatus = data.catalogPriceStatus
	v7.isOwned = data.owned
	v7.hasResellers = data.hasResellers
	v7.isOffSale = data.isOffSale
	v7.collectibleItemId = data.collectibleItemId
	v7.collectibleItemDetails = {
		quantityLimitPerUser = data.collectibleQuantityLimitPerUser,
		collectibleLowestAvailableResaleProductId = data.collectibleLowestAvailableResaleProductId,
		collectibleLowestAvailableResaleItemInstanceId = data.collectibleLowestAvailableResaleItemInstanceId,
		unitsAvailableForConsumption = data.remaining,
		hasResellers = data.hasResellers,
		lowestResalePrice = data.collectibleLowestResalePrice,
		resellableCount = data.resellableCount or v5,
		totalQuantity = data.collectibleTotalQuantity or 0
	}

	v7.assetsInBundle = v6
	v7.favoritesDetails = {
		isFavorited = data.isFavorited,
		numFavorites = data.numFavorites
	}
	return v7
end
