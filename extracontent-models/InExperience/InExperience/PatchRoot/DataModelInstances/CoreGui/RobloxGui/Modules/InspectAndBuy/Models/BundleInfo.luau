local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)

local ItemRestrictions = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.ItemRestrictions
local FFlagAXParseAdditionalItemDetailsFromCatalog = require(ParentParent.Flags.FFlagAXParseAdditionalItemDetailsFromCatalog)
local MockId = require(script.Parent.Parent.MockId)
local t1 = {
	new = function() -- line: 41
		return {}
	end
}

function t1.mock() -- line: 47
	-- upvalues: t1 (copy), MockId (copy)
	local v9 = t1.new()

	v9.name = ""
	v9.bundleId = MockId()
	v9.description = ""
	v9.bundleType = ""
	v9.creatorId = ""
	v9.creatorName = ""
	v9.productId = ""
	v9.isForSale = false
	v9.price = ""
	v9.assetIds = {}
	v9.numFavorites = 0
	v9.costumeId = ""
	v9.owned = false
	v9.isForSale = false
	v9.collectibleItemId = ""
	v9.collectibleIsLimited = nil
	v9.collectibleProductId = ""
	v9.collectibleLowestResalePrice = 0
	v9.collectibleLowestAvailableResaleProductId = ""
	v9.collectibleLowestAvailableResaleItemInstanceId = ""
	v9.collectibleQuantityLimitPerUser = 0
	v9.remaining = 0
	v9.productType = ""

	return v9
end
function t1.fromBulkPurchaseResult(p1, p2) -- line: 80
	-- upvalues: t1 (copy), ItemRestrictions (copy)
	local v12 = t1.new()
	local v13 = if not p2 or not p2.itemRestrictions then {} else p2.itemRestrictions

	v12.resellableCount = (not p2 or not p2.resellableCount) and 0 or p2.resellableCount

	if p1.status == Enum.MarketplaceItemPurchaseStatus.Success and p1.type == Enum.MarketplaceProductType.AvatarBundle then
		v12.owned = true

		if v13[ItemRestrictions.Collectible] or v13[ItemRestrictions.Limited] or v13[ItemRestrictions.LimitedUnique] then
			v12.resellableCount = v12.resellableCount + 1
		end
	end

	return v12
end
function t1.fromGetFavoriteForAsset(s1: string, b1: boolean) -- line: 109
	-- upvalues: t1 (copy)
	local v16 = t1.new()

	v16.bundleId = tostring(s1)
	v16.isFavorited = b1

	return v16
end
function t1.fromAvatarPreviewItem(p3) -- line: 116
	-- upvalues: t1 (copy)
	local v18 = t1.new()

	v18.name = p3.name
	v18.description = p3.description
	v18.price = p3.priceInRobux
	v18.isForSale = p3.isPurchasable
	v18.productId = tostring(p3.productId)
	v18.collectibleItemId = p3.collectibleItemId
	v18.collectibleProductId = p3.collectibleProductId
	v18.owned = p3.quantityOwned > 0
	v18.resellableCount = p3.quantityOwned
	v18.creatorId = tostring(p3.creator.id)
	v18.creatorName = p3.creator.name
	v18.creatorHasVerifiedBadge = p3.creator.hasVerifiedBadge
	v18.bundleId = tostring(p3.id)
	v18.bundleType = tostring(p3.bundleType)
	v18.noPriceStatus = p3.noPriceStatus

	local t2 = {}

	if p3.assetsInBundle then
		for _, v21 in p3.assetsInBundle do
			table.insert(t2, {
				id = tostring(v21.id),
				assetType = tostring(v21.assetType),
				isIncluded = v21.isIncluded,
				meta = v21.meta
			})
		end
	end

	v18.assetsInBundle = t2

	if p3.itemRestrictions then
		local t3 = {}

		for _, v24 in p3.itemRestrictions do
			t3[v24] = true
		end

		v18.itemRestrictions = t3
	end

	return v18
end
function t1.fromGetAssetBundles(p4) -- line: 161
	-- upvalues: t1 (copy), Constants (copy)
	local v26 = t1.new()

	v26.name = p4.name
	v26.bundleId = tostring(p4.id)
	v26.description = p4.description
	v26.bundleType = p4.bundleType
	v26.creatorId = tostring(p4.creator.id)
	v26.creatorName = p4.creator.name
	v26.productId = tostring(p4.product.id)

	if p4.collectibleItemDetail then
		v26.isForSale = p4.collectibleItemDetail.saleStatus == Constants.SaleStatus.OnSale
		v26.collectibleItemId = p4.collectibleItemDetail.collectibleItemId or ""
		v26.collectibleProductId = p4.collectibleItemDetail.collectibleProductId or ""
		v26.collectibleLowestResalePrice = p4.collectibleItemDetail.lowestResalePrice or 0
		v26.collectibleLowestAvailableResaleProductId = p4.collectibleItemDetail.lowestAvailableResaleProductId or ""
		v26.collectibleLowestAvailableResaleItemInstanceId = p4.collectibleItemDetail.lowestAvailableResaleItemInstanceId or ""
		v26.collectibleQuantityLimitPerUser = p4.collectibleItemDetail.quantityLimitPerUser or 0
		v26.productType = Constants.ProductType.CollectibleItem
		v26.price = p4.collectibleItemDetail.price
		v26.remaining = p4.collectibleItemDetail.unitsAvailable or 0
		v26.collectibleIsLimited = p4.collectibleItemDetail.collectibleItemType == "Limited"
		v26.saleLocation = p4.collectibleItemDetail.saleLocation
	end

	v26.assetIds = {}

	for _, v in pairs(p4.items) do
		if v.type == "UserOutfit" then
			v26.costumeId = tostring(v.id)
		else
			table.insert(v26.assetIds, (tostring(v.id)))
		end
	end

	return v26
end
function t1.fromGetItemDetailsV2(p5) -- line: 208
	-- upvalues: t1 (copy)
	local v30 = t1.new()

	v30.bundleId = tostring(p5.id)
	v30.isForSale = p5.isPurchasable
	v30.price = p5.price or 0
	v30.hasResellers = p5.hasResellers
	v30.collectibleItemId = p5.collectibleItemId
	v30.remaining = p5.unitsAvailableForConsumption
	v30.collectibleTotalQuantity = p5.totalQuantity
	v30.collectibleLowestResalePrice = p5.lowestResalePrice
	v30.isOffSale = p5.isOffSale
	v30.saleLocationType = p5.saleLocationType
	v30.numFavorites = p5.favoriteCount
	v30.catalogPriceStatus = p5.priceStatus

	local t4 = {}

	if p5.bundledItems then
		for _, v33 in p5.bundledItems do
			table.insert(t4, {
				id = tostring(v33.id),
				name = v33.name
			})
		end
	end

	v30.assetsInBundle = t4

	return v30
end
function t1.fromGetItemDetails(p6) -- line: 240
	-- upvalues: t1 (copy), FFlagAXParseAdditionalItemDetailsFromCatalog (copy)
	local v35 = t1.new()

	v35.bundleId = tostring(p6.Id)
	v35.owned = p6.Owned
	v35.isForSale = p6.IsPurchasable
	v35.price = p6.Price or 0
	v35.hasResellers = p6.HasResellers
	v35.collectibleItemId = p6.CollectibleItemId

	if FFlagAXParseAdditionalItemDetailsFromCatalog then
		v35.remaining = p6.UnitsAvailableForConsumption
		v35.collectibleTotalQuantity = p6.TotalQuantity
		v35.collectibleLowestResalePrice = p6.LowestResalePrice
		v35.isOffSale = p6.IsOffSale
		v35.saleLocationType = p6.SaleLocationType
		v35.numFavorites = p6.FavoriteCount
		v35.catalogPriceStatus = p6.PriceStatus

		local t5 = {}

		for _, v38 in p6.BundledItems do
			table.insert(t5, {
				id = tostring(v38.Id),
				name = v38.Name
			})
		end

		v35.assetsInBundle = t5
	end

	return v35
end
function t1.fromGetBundleFavoriteCount(p7, p8) -- line: 273
	-- upvalues: t1 (copy)
	local v41 = t1.new()

	v41.bundleId = tostring(p7)
	v41.numFavorites = p8

	return v41
end
function t1.fromGetEconomyProductInfo(p9, p10, p11, p12) -- line: 280
	-- upvalues: t1 (copy)
	local v46 = t1.new()

	v46.bundleId = tostring(p10)
	v46.owned = p9
	v46.price = p11
	v46.isForSale = p12

	return v46
end
function t1.fromPurchaseSuccess(p13) -- line: 289
	-- upvalues: t1 (copy)
	local v48 = t1.new()

	v48.bundleId = tostring(p13)
	v48.owned = true

	return v48
end
function t1.getSaleDetailsForCollectibles(p14) -- line: 296
	-- upvalues: Dash (copy), Constants (copy)
	local v50 = Dash.joinDeep({}, p14)

	if p14.productType == Constants.ProductType.CollectibleItem then
		local saleLocation = v50.saleLocation
		local v52 = saleLocation and saleLocation.saleLocationTypeId ~= Constants.SaleLocationType.ShopOnly
		local v53 = saleLocation and saleLocation.saleLocationTypeId ~= Constants.SaleLocationType.ShopAndExperiencesById
		local v54 = saleLocation and (saleLocation.saleLocationTypeId == Constants.SaleLocationType.ShopAndExperiencesById and (type(saleLocation.universeIds) == "table" and table.find(saleLocation.universeIds, game.GameId) ~= nil))
		local v55 = saleLocation and saleLocation.saleLocationTypeId ~= Constants.SaleLocationType.ExperiencesDevApiOnly

		v50.isForSale = v50.isForSale and (v52 and ((v53 or v54) and v55))

		if not p14.collectibleIsLimited then
			v50.isForSale = v50.isForSale and not v50.owned
		end
	end

	return v50
end

return t1
