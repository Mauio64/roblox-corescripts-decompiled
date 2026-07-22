local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local FFlagAXEnableIaBTimedOptionsBulkPurchase = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableIaBTimedOptionsBulkPurchase
local ParentParent = script.Parent.Parent
local MockId = require(ParentParent.MockId)
local Constants = require(ParentParent.Constants)

require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)

local ItemRestrictions = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.ItemRestrictions
local GetFFlagIBEnableCollectiblesSystemSupport = require(ParentParent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)
local t1 = {
	new = function() -- line: 57
		return {}
	end
}

function t1.mock() -- line: 63
	-- upvalues: t1 (copy), MockId (copy), GetFFlagIBEnableCollectiblesSystemSupport (copy)
	local v11 = t1.new()

	v11.name = ""
	v11.assetId = MockId()
	v11.assetTypeId = ""
	v11.creatorId = ""
	v11.creatorName = ""
	v11.creatorHasVerifiedBadge = false
	v11.owned = false
	v11.isForSale = false
	v11.description = ""
	v11.price = ""
	v11.productId = ""
	v11.isLimited = false
	v11.isLimitedUnique = not GetFFlagIBEnableCollectiblesSystemSupport() and nil
	v11.collectibleIsLimited = not GetFFlagIBEnableCollectiblesSystemSupport() and nil
	v11.bundlesAssetIsIn = {}
	v11.parentBundleId = nil
	v11.numFavorites = 0
	v11.minimumMembershipLevel = 0
	v11.collectibleItemId = ""
	v11.collectibleProductId = ""
	v11.collectibleLowestResalePrice = 0
	v11.collectibleLowestAvailableResaleProductId = ""
	v11.collectibleLowestAvailableResaleItemInstanceId = ""
	v11.collectibleQuantityLimitPerUser = 0
	v11.remaining = 0
	v11.creatingUniverseId = nil

	return v11
end
function t1.fromBulkPurchaseResult(p1, p2) -- line: 105
	-- upvalues: t1 (copy), ItemRestrictions (copy)
	local v14 = t1.new()
	local v15 = if not p2 or not p2.itemRestrictions then {} else p2.itemRestrictions

	v14.resellableCount = (not p2 or not p2.resellableCount) and 0 or p2.resellableCount

	if p1.status == Enum.MarketplaceItemPurchaseStatus.Success and p1.type == Enum.MarketplaceProductType.AvatarAsset then
		v14.owned = true

		if v15[ItemRestrictions.Collectible] or v15[ItemRestrictions.Limited] or v15[ItemRestrictions.LimitedUnique] then
			v14.resellableCount = v14.resellableCount + 1
		end
	end

	return v14
end
function t1.fromAvatarPreviewItem(p3) -- line: 127
	-- upvalues: t1 (copy)
	local v17 = t1.new()

	v17.name = p3.name
	v17.description = p3.description
	v17.price = p3.priceInRobux
	v17.productId = tostring(p3.productId)
	v17.collectibleItemId = p3.collectibleItemId
	v17.owned = p3.quantityOwned > 0
	v17.resellableCount = p3.quantityOwned
	v17.creatorId = tostring(p3.creator.id)
	v17.creatorName = p3.creator.name
	v17.creatorHasVerifiedBadge = p3.creator.hasVerifiedBadge
	v17.assetId = tostring(p3.id)
	v17.assetTypeId = tostring(p3.assetType)
	v17.productId = tostring(p3.productId)
	v17.isForSale = p3.isPurchasable
	v17.noPriceStatus = p3.noPriceStatus
	v17.meta = p3.meta

	if p3.itemRestrictions then
		local t2 = {}

		for _, v20 in p3.itemRestrictions do
			t2[v20] = true
		end

		v17.itemRestrictions = t2
	end

	return v17
end
function t1.fromGetProductInfo(p4) -- line: 158
	-- upvalues: t1 (copy), Constants (copy), GetFFlagIBEnableCollectiblesSystemSupport (copy)
	local v22 = t1.new()

	v22.name = p4.Name
	v22.description = p4.Description
	v22.price = p4.PriceInRobux
	v22.productType = p4.ProductType
	v22.remaining = p4.Remaining
	v22.creatorId = tostring(p4.Creator.Id)
	v22.creatorName = p4.Creator.Name
	v22.assetId = tostring(p4.AssetId)
	v22.assetTypeId = tostring(p4.AssetTypeId)
	v22.productId = tostring(p4.ProductId)
	v22.isForSale = p4.IsForSale
	v22.canBeSoldInThisGame = p4.CanBeSoldInThisGame
	v22.saleLocation = p4.SaleLocation
	v22.remaining = p4.Remaining or 0

	if v22.productType == Constants.ProductType.CollectibleItem then
		v22.collectibleItemId = p4.CollectibleItemId or ""
		v22.collectibleProductId = p4.CollectibleProductId or ""

		if p4.CollectiblesItemDetails then
			v22.collectibleLowestResalePrice = p4.CollectiblesItemDetails.CollectibleLowestResalePrice or 0
			v22.collectibleLowestAvailableResaleProductId = p4.CollectiblesItemDetails.CollectibleLowestAvailableResaleProductId or ""
			v22.collectibleLowestAvailableResaleItemInstanceId = p4.CollectiblesItemDetails.CollectibleLowestAvailableResaleItemInstanceId or ""
			v22.collectibleQuantityLimitPerUser = p4.CollectiblesItemDetails.CollectibleQuantityLimitPerUser or 0
			v22.collectibleIsLimited = p4.CollectiblesItemDetails.IsLimited
		end
	end

	v22.creatorHasVerifiedBadge = p4.Creator.HasVerifiedBadge

	if GetFFlagIBEnableCollectiblesSystemSupport() then
		v22.isLimited = p4.IsLimited
		v22.isLimitedUnique = p4.IsLimitedUnique

		return v22
	end

	v22.isLimited = p4.IsLimited or p4.IsLimitedUnique

	return v22
end
function t1.fromHumanoidDescription(p5) -- line: 203
	-- upvalues: t1 (copy)
	local v24 = t1.new()

	v24.assetId = tostring(p5)

	return v24
end
function t1.fromHumanoidDescriptionAccessory(p6) -- line: 211
	-- upvalues: t1 (copy)
	local v26 = t1.new()

	v26.assetId = tostring(p6.AssetId)
	v26.meta = {}
	v26.meta.position = {
		x = math.round(p6.Position.X * 100) / 100,
		y = math.round(p6.Position.Y * 100) / 100,
		z = math.round(p6.Position.Z * 100) / 100
	}
	v26.meta.rotation = {
		x = math.round(p6.Rotation.X * 100) / 100,
		y = math.round(p6.Rotation.Y * 100) / 100,
		z = math.round(p6.Rotation.Z * 100) / 100
	}
	v26.meta.scale = {
		x = math.round(p6.Scale.X * 100) / 100,
		y = math.round(p6.Scale.Y * 100) / 100,
		z = math.round(p6.Scale.Z * 100) / 100
	}

	if p6.IsLayered then
		v26.meta.order = p6.Order
	end

	return v26
end
function t1.fromGetAssetBundles(p7, p8) -- line: 241
	-- upvalues: t1 (copy)
	local v29 = t1.new()

	v29.assetId = tostring(p7)
	v29.bundlesAssetIsIn = p8

	return v29
end
function t1.fromGetFavoriteForAsset(s1: string, b1: boolean) -- line: 251
	-- upvalues: t1 (copy)
	local v32 = t1.new()

	v32.assetId = tostring(s1)
	v32.isFavorited = b1

	return v32
end
function t1.fromBundleInfo(p9, p10) -- line: 258
	-- upvalues: t1 (copy), Constants (copy)
	local v35 = t1.new()

	v35.assetId = tostring(p9)
	v35.parentBundleId = p10.bundleId
	v35.bundlesAssetIsIn = { p10.bundleId }
	v35.collectibleItemId = p10.collectibleItemId
	v35.collectibleProductId = p10.collectibleProductId
	v35.collectibleLowestResalePrice = p10.collectibleLowestResalePrice
	v35.collectibleLowestAvailableResaleProductId = p10.collectibleLowestAvailableResaleProductId
	v35.collectibleLowestAvailableResaleItemInstanceId = p10.collectibleLowestAvailableResaleItemInstanceId
	v35.collectibleQuantityLimitPerUser = p10.collectibleQuantityLimitPerUser
	v35.collectibleIsLimited = p10.collectibleIsLimited
	v35.isForSale = p10.isForSale
	v35.remaining = p10.remaining
	v35.owned = p10.owned

	if not v35.collectibleIsLimited then
		v35.isForSale = v35.isForSale and not v35.owned
	end

	v35.description = p10.description or ""
	v35.productType = Constants.ProductType.CollectibleItem

	if p10.price then
		v35.price = p10.price
	end

	return v35
end
function t1.fromGetAssetFavoriteCount(p11, p12) -- line: 300
	-- upvalues: t1 (copy)
	local v38 = t1.new()

	v38.assetId = tostring(p11)
	v38.numFavorites = p12

	return v38
end
function t1.fromGetEconomyProductInfo(p13, p14, p15, p16, p17) -- line: 309
	-- upvalues: t1 (copy)
	local v44 = t1.new()

	v44.assetId = tostring(p13.assetId)
	v44.owned = p14

	if p15 then
		v44.price = p15
	end

	v44.isForSale = p16
	v44.premiumPricing = p17

	return v44
end
function t1.fromGetItemDetailsV2(p18) -- line: 323
	-- upvalues: t1 (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy)
	local v46 = t1.new()

	v46.assetId = tostring(p18.id)
	v46.isForSale = p18.isPurchasable
	v46.price = p18.price or 0
	v46.hasResellers = p18.hasResellers
	v46.collectibleItemId = p18.collectibleItemId

	local t3 = {}

	if p18.itemRestrictions then
		for _, v49 in p18.itemRestrictions do
			t3[v49] = true
		end

		v46.itemRestrictions = t3
	end

	v46.saleLocationType = p18.saleLocationType
	v46.remaining = p18.unitsAvailableForConsumption
	v46.collectibleTotalQuantity = p18.totalQuantity
	v46.collectibleLowestResalePrice = p18.lowestResalePrice
	v46.isOffSale = p18.isOffSale
	v46.saleLocationType = p18.saleLocationType
	v46.numFavorites = p18.favoriteCount
	v46.catalogPriceStatus = p18.priceStatus

	if FFlagAXEnableIaBTimedOptionsBulkPurchase then
		v46.timedOptions = p18.timedOptions
	end

	return v46
end
function t1.fromGetItemDetails(p19) -- line: 356
	-- upvalues: t1 (copy)
	local v51 = t1.new()

	v51.assetId = tostring(p19.Id)
	v51.owned = p19.Owned
	v51.isForSale = p19.IsPurchasable
	v51.price = p19.Price or 0
	v51.hasResellers = p19.HasResellers
	v51.collectibleItemId = p19.CollectibleItemId

	local t4 = {}

	if p19.ItemRestrictions then
		for _, v54 in p19.ItemRestrictions do
			t4[v54] = true
		end

		v51.itemRestrictions = t4
	end

	v51.saleLocationType = p19.SaleLocationType
	v51.remaining = p19.UnitsAvailableForConsumption
	v51.collectibleTotalQuantity = p19.TotalQuantity
	v51.collectibleLowestResalePrice = p19.LowestResalePrice
	v51.isOffSale = p19.IsOffSale
	v51.saleLocationType = p19.SaleLocationType
	v51.numFavorites = p19.FavoriteCount
	v51.catalogPriceStatus = p19.PriceStatus
	v51.creatingUniverseId = p19.CreatingUniverseId

	return v51
end
function t1.fromPurchaseSuccess(p20) -- line: 388
	-- upvalues: t1 (copy)
	local v56 = t1.new()

	v56.assetId = tostring(p20)
	v56.owned = true

	return v56
end
function t1.fromGetVersionInfo(p21, p22) -- line: 401
	-- upvalues: t1 (copy)
	local v59 = t1.new()

	v59.assetId = tostring(p21)
	v59.creatingUniverseId = if not p22.creatingUniverseId then nil else tostring(p22.creatingUniverseId)

	return v59
end
function t1.getSaleDetailsForCollectibles(p23) -- line: 412
	-- upvalues: Dash (copy), Constants (copy)
	local v61 = Dash.joinDeep({}, p23)
	local saleLocation = p23.saleLocation

	if p23.productType == Constants.ProductType.CollectibleItem then
		local v63 = saleLocation and saleLocation.SaleLocationType ~= Constants.SaleLocationType.ShopOnly
		local v64 = saleLocation and saleLocation.SaleLocationType ~= Constants.SaleLocationType.ShopAndExperiencesById
		local v65 = saleLocation and (saleLocation.SaleLocationType == Constants.SaleLocationType.ShopAndExperiencesById and (type(saleLocation.UniverseIds) == "table" and table.find(saleLocation.UniverseIds, game.GameId) ~= nil))
		local v66 = saleLocation and saleLocation.SaleLocationType ~= Constants.SaleLocationType.ExperiencesDevApiOnly

		v61.isForSale = p23.isForSale and (p23.canBeSoldInThisGame and (v63 and ((v64 or v65) and v66)))

		if not p23.collectibleIsLimited then
			v61.isForSale = v61.isForSale and not v61.owned

			return v61
		end
	else
		v61.isForSale = p23.isForSale and p23.canBeSoldInThisGame

		if p23.canBeSoldInThisGame == nil then
			v61.isForSale = p23.isForSale
		end
	end

	return v61
end

return t1
