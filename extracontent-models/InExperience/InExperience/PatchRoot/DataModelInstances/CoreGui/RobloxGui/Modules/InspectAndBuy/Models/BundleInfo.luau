local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)

local ItemRestrictions = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.ItemRestrictions
local MockId = require(script.Parent.Parent.MockId)
local t1 = {
	new = function() -- line: 38
		return {}
	end
}

function t1.mock() -- line: 44
	-- upvalues: t1 (copy), MockId (copy)
	local v8 = t1.new()

	v8.name = ""
	v8.bundleId = MockId()
	v8.description = ""
	v8.bundleType = ""
	v8.creatorId = ""
	v8.creatorName = ""
	v8.productId = ""
	v8.isForSale = false
	v8.price = ""
	v8.assetIds = {}
	v8.numFavorites = 0
	v8.costumeId = ""
	v8.owned = false
	v8.isForSale = false
	v8.collectibleItemId = ""
	v8.collectibleIsLimited = nil
	v8.collectibleProductId = ""
	v8.collectibleLowestResalePrice = 0
	v8.collectibleLowestAvailableResaleProductId = ""
	v8.collectibleLowestAvailableResaleItemInstanceId = ""
	v8.collectibleQuantityLimitPerUser = 0
	v8.remaining = 0
	v8.productType = ""

	return v8
end
function t1.fromBulkPurchaseResult(p1, p2) -- line: 77
	-- upvalues: t1 (copy), ItemRestrictions (copy)
	local v11 = t1.new()
	local v12 = if not p2 or not p2.itemRestrictions then {} else p2.itemRestrictions

	v11.resellableCount = (not p2 or not p2.resellableCount) and 0 or p2.resellableCount

	if p1.status == Enum.MarketplaceItemPurchaseStatus.Success and p1.type == Enum.MarketplaceProductType.AvatarBundle then
		v11.owned = true

		if v12[ItemRestrictions.Collectible] or v12[ItemRestrictions.Limited] or v12[ItemRestrictions.LimitedUnique] then
			v11.resellableCount = v11.resellableCount + 1
		end
	end

	return v11
end
function t1.fromGetFavoriteForAsset(s1: string, b1: boolean) -- line: 106
	-- upvalues: t1 (copy)
	local v15 = t1.new()

	v15.bundleId = tostring(s1)
	v15.isFavorited = b1

	return v15
end
function t1.fromAvatarPreviewItem(p3) -- line: 113
	-- upvalues: t1 (copy)
	local v17 = t1.new()

	v17.name = p3.name
	v17.description = p3.description
	v17.price = p3.priceInRobux
	v17.isForSale = p3.isPurchasable
	v17.productId = tostring(p3.productId)
	v17.collectibleItemId = p3.collectibleItemId
	v17.collectibleProductId = p3.collectibleProductId
	v17.owned = p3.quantityOwned > 0
	v17.resellableCount = p3.quantityOwned
	v17.creatorId = tostring(p3.creator.id)
	v17.creatorName = p3.creator.name
	v17.creatorHasVerifiedBadge = p3.creator.hasVerifiedBadge
	v17.bundleId = tostring(p3.id)
	v17.bundleType = tostring(p3.bundleType)
	v17.noPriceStatus = p3.noPriceStatus

	local t2 = {}

	if p3.assetsInBundle then
		for _, v20 in p3.assetsInBundle do
			table.insert(t2, {
				id = tostring(v20.id),
				assetType = tostring(v20.assetType),
				isIncluded = v20.isIncluded,
				meta = v20.meta
			})
		end
	end

	v17.assetsInBundle = t2

	if p3.itemRestrictions then
		local t3 = {}

		for _, v23 in p3.itemRestrictions do
			t3[v23] = true
		end

		v17.itemRestrictions = t3
	end

	return v17
end
function t1.fromGetAssetBundles(p4) -- line: 158
	-- upvalues: t1 (copy), Constants (copy)
	local v25 = t1.new()

	v25.name = p4.name
	v25.bundleId = tostring(p4.id)
	v25.description = p4.description
	v25.bundleType = p4.bundleType
	v25.creatorId = tostring(p4.creator.id)
	v25.creatorName = p4.creator.name
	v25.productId = tostring(p4.product.id)

	if p4.collectibleItemDetail then
		v25.isForSale = p4.collectibleItemDetail.saleStatus == Constants.SaleStatus.OnSale
		v25.collectibleItemId = p4.collectibleItemDetail.collectibleItemId or ""
		v25.collectibleProductId = p4.collectibleItemDetail.collectibleProductId or ""
		v25.collectibleLowestResalePrice = p4.collectibleItemDetail.lowestResalePrice or 0
		v25.collectibleLowestAvailableResaleProductId = p4.collectibleItemDetail.lowestAvailableResaleProductId or ""
		v25.collectibleLowestAvailableResaleItemInstanceId = p4.collectibleItemDetail.lowestAvailableResaleItemInstanceId or ""
		v25.collectibleQuantityLimitPerUser = p4.collectibleItemDetail.quantityLimitPerUser or 0
		v25.productType = Constants.ProductType.CollectibleItem
		v25.price = p4.collectibleItemDetail.price
		v25.remaining = p4.collectibleItemDetail.unitsAvailable or 0
		v25.collectibleIsLimited = p4.collectibleItemDetail.collectibleItemType == "Limited"
		v25.saleLocation = p4.collectibleItemDetail.saleLocation
	end

	v25.assetIds = {}

	for _, v in pairs(p4.items) do
		if v.type == "UserOutfit" then
			v25.costumeId = tostring(v.id)
		else
			table.insert(v25.assetIds, (tostring(v.id)))
		end
	end

	return v25
end
function t1.fromGetItemDetailsV2(p5) -- line: 205
	-- upvalues: t1 (copy)
	local v29 = t1.new()

	v29.bundleId = tostring(p5.id)
	v29.isForSale = p5.isPurchasable
	v29.price = p5.price or 0
	v29.hasResellers = p5.hasResellers
	v29.collectibleItemId = p5.collectibleItemId
	v29.remaining = p5.unitsAvailableForConsumption
	v29.collectibleTotalQuantity = p5.totalQuantity
	v29.collectibleLowestResalePrice = p5.lowestResalePrice
	v29.isOffSale = p5.isOffSale
	v29.saleLocationType = p5.saleLocationType
	v29.numFavorites = p5.favoriteCount
	v29.catalogPriceStatus = p5.priceStatus

	local t4 = {}

	if p5.bundledItems then
		for _, v32 in p5.bundledItems do
			table.insert(t4, {
				id = tostring(v32.id),
				name = v32.name
			})
		end
	end

	v29.assetsInBundle = t4

	return v29
end
function t1.fromGetItemDetails(p6) -- line: 237
	-- upvalues: t1 (copy)
	local v34 = t1.new()

	v34.bundleId = tostring(p6.Id)
	v34.owned = p6.Owned
	v34.isForSale = p6.IsPurchasable
	v34.price = p6.Price or 0
	v34.hasResellers = p6.HasResellers
	v34.collectibleItemId = p6.CollectibleItemId
	v34.remaining = p6.UnitsAvailableForConsumption
	v34.collectibleTotalQuantity = p6.TotalQuantity
	v34.collectibleLowestResalePrice = p6.LowestResalePrice
	v34.isOffSale = p6.IsOffSale
	v34.saleLocationType = p6.SaleLocationType
	v34.numFavorites = p6.FavoriteCount
	v34.catalogPriceStatus = p6.PriceStatus

	local t5 = {}

	if p6.BundledItems then
		for _, v37 in p6.BundledItems do
			table.insert(t5, {
				id = tostring(v37.Id),
				name = v37.Name
			})
		end
	end

	v34.assetsInBundle = t5

	return v34
end
function t1.fromGetBundleFavoriteCount(p7, p8) -- line: 270
	-- upvalues: t1 (copy)
	local v40 = t1.new()

	v40.bundleId = tostring(p7)
	v40.numFavorites = p8

	return v40
end
function t1.fromGetEconomyProductInfo(p9, p10, p11, p12) -- line: 277
	-- upvalues: t1 (copy)
	local v45 = t1.new()

	v45.bundleId = tostring(p10)
	v45.owned = p9
	v45.price = p11
	v45.isForSale = p12

	return v45
end
function t1.fromPurchaseSuccess(p13) -- line: 286
	-- upvalues: t1 (copy)
	local v47 = t1.new()

	v47.bundleId = tostring(p13)
	v47.owned = true

	return v47
end
function t1.getSaleDetailsForCollectibles(p14) -- line: 293
	-- upvalues: Dash (copy), Constants (copy)
	local v49 = Dash.joinDeep({}, p14)

	if p14.productType == Constants.ProductType.CollectibleItem then
		local saleLocation = v49.saleLocation
		local v51 = saleLocation and saleLocation.saleLocationTypeId ~= Constants.SaleLocationType.ShopOnly
		local v52 = saleLocation and saleLocation.saleLocationTypeId ~= Constants.SaleLocationType.ShopAndExperiencesById
		local v53 = saleLocation and (saleLocation.saleLocationTypeId == Constants.SaleLocationType.ShopAndExperiencesById and (type(saleLocation.universeIds) == "table" and table.find(saleLocation.universeIds, game.GameId) ~= nil))
		local v54 = saleLocation and saleLocation.saleLocationTypeId ~= Constants.SaleLocationType.ExperiencesDevApiOnly

		v49.isForSale = v49.isForSale and (v51 and ((v52 or v53) and v54))

		if not p14.collectibleIsLimited then
			v49.isForSale = v49.isForSale and not v49.owned
		end
	end

	return v49
end

return t1
