local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent

require(AvatarExperienceInspectAndBuy.Types)

local AXCommon = require(AvatarExperienceInspectAndBuy.Parent.AXCommon)
local ItemTypeEnum = AXCommon.Enums.ItemTypeEnum
local SalesLocationType = AXCommon.Enums.SalesLocationType
local tutils = require(AvatarExperienceInspectAndBuyParent.tutils)

return function(p1, t1: {[any]: any}?) -- line: 20
	-- upvalues: tutils (copy), ItemTypeEnum (copy), SalesLocationType (copy)
	local n1 = 0

	if t1 then
		n1 = tutils.fieldCount(t1)
	end

	local t2 = {}

	if p1.assetsInBundle then
		for _, v12 in p1.assetsInBundle do
			table.insert(t2, {
				id = tostring(v12.id),
				assetType = tostring(v12.assetType),
				isIncluded = v12.isIncluded,
				meta = v12.meta,
				name = v12.name
			})
		end
	end

	return {
		id = p1.bundleId,
		name = p1.name,
		description = p1.description,
		itemType = ItemTypeEnum.Bundle,
		itemSubType = p1.bundleType,
		creator = {
			creatorId = p1.creatorId or "",
			creatorName = p1.creatorName or "",
			creatorHasVerifiedBadge = p1.creatorHasVerifiedBadge or false
		},
		saleLocationType = p1.saleLocationType or SalesLocationType.Invalid,
		itemRestrictions = p1.itemRestrictions or {},
		priceInRobux = p1.price,
		noPriceStatus = p1.noPriceStatus,
		catalogPriceStatus = p1.catalogPriceStatus,
		isOwned = p1.owned,
		hasResellers = p1.hasResellers,
		isOffSale = p1.isOffSale,
		collectibleItemId = p1.collectibleItemId,
		collectibleItemDetails = {
			quantityLimitPerUser = p1.collectibleQuantityLimitPerUser,
			collectibleLowestAvailableResaleProductId = p1.collectibleLowestAvailableResaleProductId,
			collectibleLowestAvailableResaleItemInstanceId = p1.collectibleLowestAvailableResaleItemInstanceId,
			unitsAvailableForConsumption = p1.remaining,
			hasResellers = p1.hasResellers,
			lowestResalePrice = p1.collectibleLowestResalePrice,
			resellableCount = p1.resellableCount or n1,
			totalQuantity = p1.collectibleTotalQuantity or 0
		},
		assetsInBundle = t2,
		favoritesDetails = {
			isFavorited = p1.isFavorited,
			numFavorites = p1.numFavorites
		}
	}
end
