local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
require(AvatarExperienceInspectAndBuy.Types)
local AXCommon = require(AvatarExperienceInspectAndBuy.Parent.AXCommon)
local AvatarExperienceModel = require(AvatarExperienceInspectAndBuy.Parent.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local SalesLocationType = AXCommon.Enums.SalesLocationType
local tutils = require(parent.tutils)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards

return function(data, p)
	local v = not p and 0 or tutils.fieldCount(p)

	local assetsInBundle = {}

	if data.assetsInBundle then
		for _, v2 in data.assetsInBundle do
			table.insert(assetsInBundle, {
				id = tostring(v2.id),
				assetType = tostring(v2.assetType),
				isIncluded = v2.isIncluded,
				meta = v2.meta,
				name = v2.name
			})
		end
	end

	local v2 = {
		id = data.bundleId,
		name = data.name,
		description = data.description,
		itemType = ItemTypeEnum.Bundle,
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
	local itemLicensingInfo

	if FFlagAXMarketplaceLicensingItemCards then
		itemLicensingInfo = data.itemLicensingInfo
	end

	v2.itemLicensingInfo = itemLicensingInfo
	v2.saleLocationType = data.saleLocationType or SalesLocationType.Invalid
	v2.itemRestrictions = data.itemRestrictions or {}
	v2.priceInRobux = data.price
	v2.noPriceStatus = data.noPriceStatus
	v2.catalogPriceStatus = data.catalogPriceStatus
	v2.isOwned = data.owned
	v2.hasResellers = data.hasResellers
	v2.isOffSale = data.isOffSale
	v2.collectibleItemId = data.collectibleItemId
	v2.collectibleItemDetails = {
		quantityLimitPerUser = data.collectibleQuantityLimitPerUser,
		collectibleLowestAvailableResaleProductId = data.collectibleLowestAvailableResaleProductId,
		collectibleLowestAvailableResaleItemInstanceId = data.collectibleLowestAvailableResaleItemInstanceId,
		unitsAvailableForConsumption = data.remaining,
		hasResellers = data.hasResellers,
		lowestResalePrice = data.collectibleLowestResalePrice,
		resellableCount = data.resellableCount or v,
		totalQuantity = data.collectibleTotalQuantity or 0
	}

	v2.assetsInBundle = assetsInBundle
	v2.favoritesDetails = { isFavorited = data.isFavorited, numFavorites = data.numFavorites }
	return v2
end
