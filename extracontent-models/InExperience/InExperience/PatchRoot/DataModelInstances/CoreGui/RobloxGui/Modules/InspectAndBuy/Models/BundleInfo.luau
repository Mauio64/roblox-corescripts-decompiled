local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)

local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMarketplaceLicensing = AvatarExperienceFlags.FFlagAXMarketplaceLicensing

local parent = script.Parent.Parent

local Constants = require(parent.Constants)
require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local ItemRestrictions = AvatarExperienceCommon.Enums.ItemRestrictions
local getRawItemLicensingInfo = AvatarExperienceCommon.Utils.getRawItemLicensingInfo
local parseItemLicensing = AvatarExperienceCommon.Utils.parseItemLicensing

local MockId = require(script.Parent.Parent.MockId)
local BundleInfo = {}

function BundleInfo.new()
	return {}
end

function BundleInfo.mock()
	local v = BundleInfo.new()

	v.name = ""
	v.bundleId = MockId()
	v.description = ""
	v.bundleType = ""
	v.creatorId = ""
	v.creatorName = ""
	v.productId = ""
	v.isForSale = false
	v.price = ""
	v.assetIds = {}
	v.numFavorites = 0
	v.costumeId = ""
	v.owned = false
	v.isForSale = false
	v.collectibleItemId = ""
	v.collectibleIsLimited = nil
	v.collectibleProductId = ""
	v.collectibleLowestResalePrice = 0
	v.collectibleLowestAvailableResaleProductId = ""
	v.collectibleLowestAvailableResaleItemInstanceId = ""
	v.collectibleQuantityLimitPerUser = 0
	v.remaining = 0
	v.productType = ""

	return v
end

function BundleInfo.fromBulkPurchaseResult(p, p2)
	local v = BundleInfo.new()
	local v2 = not (p2 and p2.itemRestrictions) and {} or p2.itemRestrictions
	v.resellableCount = not (p2 and p2.resellableCount) and 0 or p2.resellableCount

	if
		p.status == Enum.MarketplaceItemPurchaseStatus.Success
		and p.type == Enum.MarketplaceProductType.AvatarBundle
	then
		v.owned = true

		if v2[ItemRestrictions.Collectible] or v2[ItemRestrictions.Limited] or v2[ItemRestrictions.LimitedUnique] then
			v.resellableCount += 1
		end
	end

	return v
end

function BundleInfo.fromGetFavoriteForAsset(p: string, isFavorited: boolean)
	local v = BundleInfo.new()
	v.bundleId = tostring(p)
	v.isFavorited = isFavorited
	return v
end

function BundleInfo.fromAvatarPreviewItem(data)
	local v = BundleInfo.new()

	v.name = data.name
	v.description = data.description
	v.price = data.priceInRobux
	v.isForSale = data.isPurchasable
	v.productId = tostring(data.productId)
	v.collectibleItemId = data.collectibleItemId
	v.collectibleProductId = data.collectibleProductId
	v.owned = data.quantityOwned > 0
	v.resellableCount = data.quantityOwned
	v.creatorId = tostring(data.creator.id)
	v.creatorName = data.creator.name
	v.creatorHasVerifiedBadge = data.creator.hasVerifiedBadge
	v.bundleId = tostring(data.id)
	v.bundleType = tostring(data.bundleType)
	v.noPriceStatus = data.noPriceStatus

	if FFlagAXMarketplaceLicensing then
		v.itemLicensingInfo = parseItemLicensing(getRawItemLicensingInfo(data))
	end

	local assetsInBundle = {}

	if data.assetsInBundle then
		for _, v2 in data.assetsInBundle do
			table.insert(assetsInBundle, {
				id = tostring(v2.id),
				assetType = tostring(v2.assetType),
				isIncluded = v2.isIncluded,
				meta = v2.meta
			})
		end
	end

	v.assetsInBundle = assetsInBundle

	if not data.itemRestrictions then
		return v
	end

	local itemRestrictionSet = {}

	for _, itemRestriction in data.itemRestrictions do
		itemRestrictionSet[itemRestriction] = true
	end

	v.itemRestrictions = itemRestrictionSet

	return v
end

function BundleInfo.fromGetAssetBundles(data)
	local result = BundleInfo.new()

	result.name = data.name
	result.bundleId = tostring(data.id)
	result.description = data.description
	result.bundleType = data.bundleType
	result.creatorId = tostring(data.creator.id)
	result.creatorName = data.creator.name
	result.productId = tostring(data.product.id)

	if data.collectibleItemDetail then
		result.isForSale = data.collectibleItemDetail.saleStatus == Constants.SaleStatus.OnSale
		result.collectibleItemId = data.collectibleItemDetail.collectibleItemId or ""
		result.collectibleProductId = data.collectibleItemDetail.collectibleProductId or ""
		result.collectibleLowestResalePrice = data.collectibleItemDetail.lowestResalePrice or 0
		result.collectibleLowestAvailableResaleProductId = data.collectibleItemDetail.lowestAvailableResaleProductId
			or ""

		result.collectibleLowestAvailableResaleItemInstanceId = data.collectibleItemDetail.lowestAvailableResaleItemInstanceId
			or ""

		result.collectibleQuantityLimitPerUser = data.collectibleItemDetail.quantityLimitPerUser or 0

		result.productType = Constants.ProductType.CollectibleItem

		result.price = data.collectibleItemDetail.price

		result.remaining = data.collectibleItemDetail.unitsAvailable or 0

		result.collectibleIsLimited = data.collectibleItemDetail.collectibleItemType == "Limited"

		result.saleLocation = data.collectibleItemDetail.saleLocation
	end

	result.assetIds = {}

	for _, item in pairs(data.items) do
		if item.type == "UserOutfit" then
			result.costumeId = tostring(item.id)
		else
			table.insert(result.assetIds, (tostring(item.id)))
		end
	end

	return result
end

function BundleInfo.fromGetItemDetailsV2(data)
	local v = BundleInfo.new()

	v.bundleId = tostring(data.id)
	v.isForSale = data.isPurchasable
	v.price = data.price or 0
	v.hasResellers = data.hasResellers
	v.collectibleItemId = data.collectibleItemId

	v.remaining = data.unitsAvailableForConsumption
	v.collectibleTotalQuantity = data.totalQuantity
	v.collectibleLowestResalePrice = data.lowestResalePrice
	v.isOffSale = data.isOffSale
	v.saleLocationType = data.saleLocationType
	v.numFavorites = data.favoriteCount
	v.catalogPriceStatus = data.priceStatus
	local rawItemLicensingInfo = getRawItemLicensingInfo(data)

	if FFlagAXMarketplaceLicensing and rawItemLicensingInfo ~= nil then
		v.itemLicensingInfo = parseItemLicensing(rawItemLicensingInfo) or Cryo.None
	end

	local assetsInBundle = {}

	if data.bundledItems then
		for _, bundledItem in data.bundledItems do
			table.insert(assetsInBundle, { id = tostring(bundledItem.id), name = bundledItem.name })
		end
	end

	v.assetsInBundle = assetsInBundle

	return v
end

function BundleInfo.fromGetItemDetails(data)
	local v = BundleInfo.new()

	v.bundleId = tostring(data.Id)
	v.owned = data.Owned
	v.isForSale = data.IsPurchasable
	v.price = data.Price or 0
	v.hasResellers = data.HasResellers
	v.collectibleItemId = data.CollectibleItemId

	v.remaining = data.UnitsAvailableForConsumption
	v.collectibleTotalQuantity = data.TotalQuantity
	v.collectibleLowestResalePrice = data.LowestResalePrice
	v.isOffSale = data.IsOffSale
	v.saleLocationType = data.SaleLocationType
	v.numFavorites = data.FavoriteCount
	v.catalogPriceStatus = data.PriceStatus

	local assetsInBundle = {}

	if data.BundledItems then
		for _, bundledItem in data.BundledItems do
			table.insert(assetsInBundle, { id = tostring(bundledItem.Id), name = bundledItem.Name })
		end
	end

	v.assetsInBundle = assetsInBundle

	return v
end

function BundleInfo.fromGetBundleFavoriteCount(p, numFavorites)
	local v = BundleInfo.new()
	v.bundleId = tostring(p)
	v.numFavorites = numFavorites
	return v
end

function BundleInfo.fromGetEconomyProductInfo(owned, p, price, isForSale)
	local v = BundleInfo.new()
	v.bundleId = tostring(p)
	v.owned = owned
	v.price = price
	v.isForSale = isForSale
	return v
end

function BundleInfo.fromPurchaseSuccess(p)
	local v = BundleInfo.new()
	v.bundleId = tostring(p)
	v.owned = true
	return v
end

function BundleInfo.getSaleDetailsForCollectibles(p)
	local saleDetailsForCollectibles = Dash.joinDeep({}, p)

	if p.productType ~= Constants.ProductType.CollectibleItem then
		return saleDetailsForCollectibles
	end

	local saleLocation = saleDetailsForCollectibles.saleLocation
	local v = saleLocation and saleLocation.saleLocationTypeId ~= Constants.SaleLocationType.ShopOnly

	local v2 = saleLocation and saleLocation.saleLocationTypeId ~= Constants.SaleLocationType.ShopAndExperiencesById
	local v3

	if saleLocation then
		if
			saleLocation.saleLocationTypeId == Constants.SaleLocationType.ShopAndExperiencesById
			and type(saleLocation.universeIds) == "table"
		then
			v3 = table.find(saleLocation.universeIds, game.GameId) ~= nil
		else
			v3 = false
		end
	else
		v3 = saleLocation
	end

	local v4 = saleLocation and saleLocation.saleLocationTypeId ~= Constants.SaleLocationType.ExperiencesDevApiOnly

	local isForSale = saleDetailsForCollectibles.isForSale

	if isForSale then
		if v then
			isForSale = if v2 or v3 then v4 else v3
		else
			isForSale = v
		end
	end

	saleDetailsForCollectibles.isForSale = isForSale

	if not p.collectibleIsLimited then
		saleDetailsForCollectibles.isForSale = saleDetailsForCollectibles.isForSale
			and not saleDetailsForCollectibles.owned
	end

	return saleDetailsForCollectibles
end

return BundleInfo
