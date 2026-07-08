local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local FFlagAXEnableIaBTimedOptionsBulkPurchase = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableIaBTimedOptionsBulkPurchase
local ParentParent = script.Parent.Parent
local MockId = require(ParentParent.MockId)
local Constants = require(ParentParent.Constants)

require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)

local ItemRestrictions = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.ItemRestrictions
local GetFFlagIBEnableCollectiblesSystemSupport = require(ParentParent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)
local FFlagAXParseAdditionalItemDetailsFromCatalog = require(ParentParent.Flags.FFlagAXParseAdditionalItemDetailsFromCatalog)
local t1 = {
	new = function() -- line: 60
		return {}
	end
}

function t1.mock() -- line: 66
	-- upvalues: t1 (copy), MockId (copy), GetFFlagIBEnableCollectiblesSystemSupport (copy)
	local v12 = t1.new()

	v12.name = ""
	v12.assetId = MockId()
	v12.assetTypeId = ""
	v12.creatorId = ""
	v12.creatorName = ""
	v12.creatorHasVerifiedBadge = false
	v12.owned = false
	v12.isForSale = false
	v12.description = ""
	v12.price = ""
	v12.productId = ""
	v12.isLimited = false
	v12.isLimitedUnique = not GetFFlagIBEnableCollectiblesSystemSupport() and nil
	v12.collectibleIsLimited = not GetFFlagIBEnableCollectiblesSystemSupport() and nil
	v12.bundlesAssetIsIn = {}
	v12.parentBundleId = nil
	v12.numFavorites = 0
	v12.minimumMembershipLevel = 0
	v12.collectibleItemId = ""
	v12.collectibleProductId = ""
	v12.collectibleLowestResalePrice = 0
	v12.collectibleLowestAvailableResaleProductId = ""
	v12.collectibleLowestAvailableResaleItemInstanceId = ""
	v12.collectibleQuantityLimitPerUser = 0
	v12.remaining = 0
	v12.creatingUniverseId = nil

	return v12
end
function t1.fromBulkPurchaseResult(p1, p2) -- line: 108
	-- upvalues: t1 (copy), ItemRestrictions (copy)
	local v15 = t1.new()
	local v16 = if not p2 or not p2.itemRestrictions then {} else p2.itemRestrictions

	v15.resellableCount = (not p2 or not p2.resellableCount) and 0 or p2.resellableCount

	if p1.status == Enum.MarketplaceItemPurchaseStatus.Success and p1.type == Enum.MarketplaceProductType.AvatarAsset then
		v15.owned = true

		if v16[ItemRestrictions.Collectible] or v16[ItemRestrictions.Limited] or v16[ItemRestrictions.LimitedUnique] then
			v15.resellableCount = v15.resellableCount + 1
		end
	end

	return v15
end
function t1.fromAvatarPreviewItem(p3) -- line: 130
	-- upvalues: t1 (copy)
	local v18 = t1.new()

	v18.name = p3.name
	v18.description = p3.description
	v18.price = p3.priceInRobux
	v18.productId = tostring(p3.productId)
	v18.collectibleItemId = p3.collectibleItemId
	v18.owned = p3.quantityOwned > 0
	v18.resellableCount = p3.quantityOwned
	v18.creatorId = tostring(p3.creator.id)
	v18.creatorName = p3.creator.name
	v18.creatorHasVerifiedBadge = p3.creator.hasVerifiedBadge
	v18.assetId = tostring(p3.id)
	v18.assetTypeId = tostring(p3.assetType)
	v18.productId = tostring(p3.productId)
	v18.isForSale = p3.isPurchasable
	v18.noPriceStatus = p3.noPriceStatus
	v18.meta = p3.meta

	if p3.itemRestrictions then
		local t2 = {}

		for _, v21 in p3.itemRestrictions do
			t2[v21] = true
		end

		v18.itemRestrictions = t2
	end

	return v18
end
function t1.fromGetProductInfo(p4) -- line: 161
	-- upvalues: t1 (copy), Constants (copy), GetFFlagIBEnableCollectiblesSystemSupport (copy)
	local v23 = t1.new()

	v23.name = p4.Name
	v23.description = p4.Description
	v23.price = p4.PriceInRobux
	v23.productType = p4.ProductType
	v23.remaining = p4.Remaining
	v23.creatorId = tostring(p4.Creator.Id)
	v23.creatorName = p4.Creator.Name
	v23.assetId = tostring(p4.AssetId)
	v23.assetTypeId = tostring(p4.AssetTypeId)
	v23.productId = tostring(p4.ProductId)
	v23.isForSale = p4.IsForSale
	v23.canBeSoldInThisGame = p4.CanBeSoldInThisGame
	v23.saleLocation = p4.SaleLocation
	v23.remaining = p4.Remaining or 0

	if v23.productType == Constants.ProductType.CollectibleItem then
		v23.collectibleItemId = p4.CollectibleItemId or ""
		v23.collectibleProductId = p4.CollectibleProductId or ""

		if p4.CollectiblesItemDetails then
			v23.collectibleLowestResalePrice = p4.CollectiblesItemDetails.CollectibleLowestResalePrice or 0
			v23.collectibleLowestAvailableResaleProductId = p4.CollectiblesItemDetails.CollectibleLowestAvailableResaleProductId or ""
			v23.collectibleLowestAvailableResaleItemInstanceId = p4.CollectiblesItemDetails.CollectibleLowestAvailableResaleItemInstanceId or ""
			v23.collectibleQuantityLimitPerUser = p4.CollectiblesItemDetails.CollectibleQuantityLimitPerUser or 0
			v23.collectibleIsLimited = p4.CollectiblesItemDetails.IsLimited
		end
	end

	v23.creatorHasVerifiedBadge = p4.Creator.HasVerifiedBadge

	if GetFFlagIBEnableCollectiblesSystemSupport() then
		v23.isLimited = p4.IsLimited
		v23.isLimitedUnique = p4.IsLimitedUnique

		return v23
	end

	v23.isLimited = p4.IsLimited or p4.IsLimitedUnique

	return v23
end
function t1.fromHumanoidDescription(p5) -- line: 206
	-- upvalues: t1 (copy)
	local v25 = t1.new()

	v25.assetId = tostring(p5)

	return v25
end
function t1.fromHumanoidDescriptionAccessory(p6) -- line: 214
	-- upvalues: t1 (copy)
	local v27 = t1.new()

	v27.assetId = tostring(p6.AssetId)
	v27.meta = {}
	v27.meta.position = {
		x = math.round(p6.Position.X * 100) / 100,
		y = math.round(p6.Position.Y * 100) / 100,
		z = math.round(p6.Position.Z * 100) / 100
	}
	v27.meta.rotation = {
		x = math.round(p6.Rotation.X * 100) / 100,
		y = math.round(p6.Rotation.Y * 100) / 100,
		z = math.round(p6.Rotation.Z * 100) / 100
	}
	v27.meta.scale = {
		x = math.round(p6.Scale.X * 100) / 100,
		y = math.round(p6.Scale.Y * 100) / 100,
		z = math.round(p6.Scale.Z * 100) / 100
	}

	if p6.IsLayered then
		v27.meta.order = p6.Order
	end

	return v27
end
function t1.fromGetAssetBundles(p7, p8) -- line: 244
	-- upvalues: t1 (copy)
	local v30 = t1.new()

	v30.assetId = tostring(p7)
	v30.bundlesAssetIsIn = p8

	return v30
end
function t1.fromGetFavoriteForAsset(s1: string, b1: boolean) -- line: 254
	-- upvalues: t1 (copy)
	local v33 = t1.new()

	v33.assetId = tostring(s1)
	v33.isFavorited = b1

	return v33
end
function t1.fromBundleInfo(p9, p10) -- line: 261
	-- upvalues: t1 (copy), Constants (copy)
	local v36 = t1.new()

	v36.assetId = tostring(p9)
	v36.parentBundleId = p10.bundleId
	v36.bundlesAssetIsIn = { p10.bundleId }
	v36.collectibleItemId = p10.collectibleItemId
	v36.collectibleProductId = p10.collectibleProductId
	v36.collectibleLowestResalePrice = p10.collectibleLowestResalePrice
	v36.collectibleLowestAvailableResaleProductId = p10.collectibleLowestAvailableResaleProductId
	v36.collectibleLowestAvailableResaleItemInstanceId = p10.collectibleLowestAvailableResaleItemInstanceId
	v36.collectibleQuantityLimitPerUser = p10.collectibleQuantityLimitPerUser
	v36.collectibleIsLimited = p10.collectibleIsLimited
	v36.isForSale = p10.isForSale
	v36.remaining = p10.remaining
	v36.owned = p10.owned

	if not v36.collectibleIsLimited then
		v36.isForSale = v36.isForSale and not v36.owned
	end

	v36.description = p10.description or ""
	v36.productType = Constants.ProductType.CollectibleItem

	if p10.price then
		v36.price = p10.price
	end

	return v36
end
function t1.fromGetAssetFavoriteCount(p11, p12) -- line: 303
	-- upvalues: t1 (copy)
	local v39 = t1.new()

	v39.assetId = tostring(p11)
	v39.numFavorites = p12

	return v39
end
function t1.fromGetEconomyProductInfo(p13, p14, p15, p16, p17) -- line: 312
	-- upvalues: t1 (copy)
	local v45 = t1.new()

	v45.assetId = tostring(p13.assetId)
	v45.owned = p14

	if p15 then
		v45.price = p15
	end

	v45.isForSale = p16
	v45.premiumPricing = p17

	return v45
end
function t1.fromGetItemDetailsV2(p18) -- line: 326
	-- upvalues: t1 (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy)
	local v47 = t1.new()

	v47.assetId = tostring(p18.id)
	v47.isForSale = p18.isPurchasable
	v47.price = p18.price or 0
	v47.hasResellers = p18.hasResellers
	v47.collectibleItemId = p18.collectibleItemId

	local t3 = {}

	if p18.itemRestrictions then
		for _, v50 in p18.itemRestrictions do
			t3[v50] = true
		end

		v47.itemRestrictions = t3
	end

	v47.saleLocationType = p18.saleLocationType
	v47.remaining = p18.unitsAvailableForConsumption
	v47.collectibleTotalQuantity = p18.totalQuantity
	v47.collectibleLowestResalePrice = p18.lowestResalePrice
	v47.isOffSale = p18.isOffSale
	v47.saleLocationType = p18.saleLocationType
	v47.numFavorites = p18.favoriteCount
	v47.catalogPriceStatus = p18.priceStatus

	if FFlagAXEnableIaBTimedOptionsBulkPurchase then
		v47.timedOptions = p18.timedOptions
	end

	return v47
end
function t1.fromGetItemDetails(p19) -- line: 359
	-- upvalues: t1 (copy), FFlagAXParseAdditionalItemDetailsFromCatalog (copy)
	local v52 = t1.new()

	v52.assetId = tostring(p19.Id)
	v52.owned = p19.Owned
	v52.isForSale = p19.IsPurchasable
	v52.price = p19.Price or 0
	v52.hasResellers = p19.HasResellers
	v52.collectibleItemId = p19.CollectibleItemId

	if FFlagAXParseAdditionalItemDetailsFromCatalog then
		local t4 = {}

		if p19.ItemRestrictions then
			for _, v55 in p19.ItemRestrictions do
				t4[v55] = true
			end

			v52.itemRestrictions = t4
		end

		v52.saleLocationType = p19.SaleLocationType
		v52.remaining = p19.UnitsAvailableForConsumption
		v52.collectibleTotalQuantity = p19.TotalQuantity
		v52.collectibleLowestResalePrice = p19.LowestResalePrice
		v52.isOffSale = p19.IsOffSale
		v52.saleLocationType = p19.SaleLocationType
		v52.numFavorites = p19.FavoriteCount
		v52.catalogPriceStatus = p19.PriceStatus
	end

	v52.creatingUniverseId = p19.CreatingUniverseId

	return v52
end
function t1.fromPurchaseSuccess(p20) -- line: 393
	-- upvalues: t1 (copy)
	local v57 = t1.new()

	v57.assetId = tostring(p20)
	v57.owned = true

	return v57
end
function t1.fromGetVersionInfo(p21, p22) -- line: 406
	-- upvalues: t1 (copy)
	local v60 = t1.new()

	v60.assetId = tostring(p21)
	v60.creatingUniverseId = if not p22.creatingUniverseId then nil else tostring(p22.creatingUniverseId)

	return v60
end
function t1.getSaleDetailsForCollectibles(p23) -- line: 417
	-- upvalues: Dash (copy), Constants (copy)
	local v62 = Dash.joinDeep({}, p23)
	local saleLocation = p23.saleLocation

	if p23.productType == Constants.ProductType.CollectibleItem then
		local v64 = saleLocation and saleLocation.SaleLocationType ~= Constants.SaleLocationType.ShopOnly
		local v65 = saleLocation and saleLocation.SaleLocationType ~= Constants.SaleLocationType.ShopAndExperiencesById
		local v66 = saleLocation and (saleLocation.SaleLocationType == Constants.SaleLocationType.ShopAndExperiencesById and (type(saleLocation.UniverseIds) == "table" and table.find(saleLocation.UniverseIds, game.GameId) ~= nil))
		local v67 = saleLocation and saleLocation.SaleLocationType ~= Constants.SaleLocationType.ExperiencesDevApiOnly

		v62.isForSale = p23.isForSale and (p23.canBeSoldInThisGame and (v64 and ((v65 or v66) and v67)))

		if not p23.collectibleIsLimited then
			v62.isForSale = v62.isForSale and not v62.owned

			return v62
		end
	else
		v62.isForSale = p23.isForSale and p23.canBeSoldInThisGame

		if p23.canBeSoldInThisGame == nil then
			v62.isForSale = p23.isForSale
		end
	end

	return v62
end

return t1
