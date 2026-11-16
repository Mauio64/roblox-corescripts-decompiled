local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)

local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMarketplaceLicensing = AvatarExperienceFlags.FFlagAXMarketplaceLicensing

local parent = script.Parent.Parent

local MockId = require(parent.MockId)
local Constants = require(parent.Constants)
require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local ItemRestrictions = AvatarExperienceCommon.Enums.ItemRestrictions
local getRawItemLicensingInfo = AvatarExperienceCommon.Utils.getRawItemLicensingInfo
local parseItemLicensing = AvatarExperienceCommon.Utils.parseItemLicensing

local GetFFlagIBEnableCollectiblesSystemSupport = require(parent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)

local AssetInfo = {}

function AssetInfo.new()
	return {}
end

function AssetInfo.mock()
	local v = AssetInfo.new()

	v.name = ""
	v.assetId = MockId()
	v.assetTypeId = ""
	v.creatorId = ""
	v.creatorName = ""
	v.creatorHasVerifiedBadge = false
	v.owned = false
	v.isForSale = false
	v.description = ""
	v.price = ""
	v.productId = ""
	v.isLimited = false
	v.isLimitedUnique = not GetFFlagIBEnableCollectiblesSystemSupport() and nil
	v.collectibleIsLimited = not GetFFlagIBEnableCollectiblesSystemSupport() and nil

	v.bundlesAssetIsIn = {}

	v.parentBundleId = nil
	v.numFavorites = 0
	v.minimumMembershipLevel = 0

	v.collectibleItemId = ""
	v.collectibleProductId = ""
	v.collectibleLowestResalePrice = 0
	v.collectibleLowestAvailableResaleProductId = ""
	v.collectibleLowestAvailableResaleItemInstanceId = ""
	v.collectibleQuantityLimitPerUser = 0
	v.remaining = 0
	v.creatingUniverseId = nil

	return v
end

function AssetInfo.fromBulkPurchaseResult(p, p2)
	local v = AssetInfo.new()
	local v2 = not (p2 and p2.itemRestrictions) and {} or p2.itemRestrictions
	v.resellableCount = not (p2 and p2.resellableCount) and 0 or p2.resellableCount

	if p.status == Enum.MarketplaceItemPurchaseStatus.Success and p.type == Enum.MarketplaceProductType.AvatarAsset then
		v.owned = true

		if v2[ItemRestrictions.Collectible] or v2[ItemRestrictions.Limited] or v2[ItemRestrictions.LimitedUnique] then
			v.resellableCount += 1
		end
	end

	return v
end

function AssetInfo.fromAvatarPreviewItem(data)
	local v = AssetInfo.new()

	v.name = data.name
	v.description = data.description
	v.price = data.priceInRobux
	v.productId = tostring(data.productId)
	v.collectibleItemId = data.collectibleItemId
	v.owned = data.quantityOwned > 0
	v.resellableCount = data.quantityOwned
	v.creatorId = tostring(data.creator.id)
	v.creatorName = data.creator.name
	v.creatorHasVerifiedBadge = data.creator.hasVerifiedBadge
	v.assetId = tostring(data.id)
	v.assetTypeId = tostring(data.assetType)
	v.productId = tostring(data.productId)
	v.isForSale = data.isPurchasable
	v.noPriceStatus = data.noPriceStatus
	v.meta = data.meta

	if FFlagAXMarketplaceLicensing then
		v.itemLicensingInfo = parseItemLicensing(getRawItemLicensingInfo(data))
	end

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

function AssetInfo.fromGetProductInfo(data)
	local v = AssetInfo.new()

	v.name = data.Name
	v.description = data.Description
	v.price = data.PriceInRobux
	v.productType = data.ProductType
	v.remaining = data.Remaining
	v.creatorId = tostring(data.Creator.Id)
	v.creatorName = data.Creator.Name
	v.assetId = tostring(data.AssetId)
	v.assetTypeId = tostring(data.AssetTypeId)
	v.productId = tostring(data.ProductId)

	v.isForSale = data.IsForSale
	v.canBeSoldInThisGame = data.CanBeSoldInThisGame
	v.saleLocation = data.SaleLocation
	v.remaining = data.Remaining or 0

	if v.productType == Constants.ProductType.CollectibleItem then
		v.collectibleItemId = data.CollectibleItemId or ""
		v.collectibleProductId = data.CollectibleProductId or ""

		if data.CollectiblesItemDetails then
			v.collectibleLowestResalePrice = data.CollectiblesItemDetails.CollectibleLowestResalePrice or 0
			v.collectibleLowestAvailableResaleProductId = data.CollectiblesItemDetails.CollectibleLowestAvailableResaleProductId
				or ""

			v.collectibleLowestAvailableResaleItemInstanceId = data.CollectiblesItemDetails.CollectibleLowestAvailableResaleItemInstanceId
				or ""

			v.collectibleQuantityLimitPerUser = data.CollectiblesItemDetails.CollectibleQuantityLimitPerUser or 0

			v.collectibleIsLimited = data.CollectiblesItemDetails.IsLimited
		end
	end

	v.creatorHasVerifiedBadge = data.Creator.HasVerifiedBadge

	if not GetFFlagIBEnableCollectiblesSystemSupport() then
		v.isLimited = data.IsLimited or data.IsLimitedUnique

		return v
	end

	v.isLimited = data.IsLimited
	v.isLimitedUnique = data.IsLimitedUnique
	return v
end

function AssetInfo.fromHumanoidDescription(p)
	local v = AssetInfo.new()

	v.assetId = tostring(p)

	return v
end

local function fn(p) -- 9 equivalent calls inferred from this helper
	return math.round(p * 100) / 100
end

function AssetInfo.fromHumanoidDescriptionAccessory(data)
	local v = AssetInfo.new()
	v.assetId = tostring(data.AssetId)

	v.meta = {}
	v.meta.position = { x = fn(data.Position.X), y = fn(data.Position.Y), z = fn(data.Position.Z) } -- inferred equivalent call

	v.meta.rotation = { x = fn(data.Rotation.X), y = fn(data.Rotation.Y), z = fn(data.Rotation.Z) } -- inferred equivalent call

	v.meta.scale = { x = fn(data.Scale.X), y = fn(data.Scale.Y), z = fn(data.Scale.Z) } -- inferred equivalent call

	if data.IsLayered then
		v.meta.order = data.Order
	end

	return v
end

function AssetInfo.fromGetAssetBundles(p, bundlesAssetIsIn)
	local v = AssetInfo.new()
	v.assetId = tostring(p)
	v.bundlesAssetIsIn = bundlesAssetIsIn
	return v
end

function AssetInfo.fromGetFavoriteForAsset(p: string, isFavorited: boolean)
	local v = AssetInfo.new()
	v.assetId = tostring(p)
	v.isFavorited = isFavorited
	return v
end

function AssetInfo.fromBundleInfo(p, data)
	local v = AssetInfo.new()
	v.assetId = tostring(p)
	v.parentBundleId = data.bundleId
	v.bundlesAssetIsIn = { data.bundleId }
	v.collectibleItemId = data.collectibleItemId
	v.collectibleProductId = data.collectibleProductId
	v.collectibleLowestResalePrice = data.collectibleLowestResalePrice
	v.collectibleLowestAvailableResaleProductId = data.collectibleLowestAvailableResaleProductId
	v.collectibleLowestAvailableResaleItemInstanceId = data.collectibleLowestAvailableResaleItemInstanceId
	v.collectibleQuantityLimitPerUser = data.collectibleQuantityLimitPerUser
	v.collectibleIsLimited = data.collectibleIsLimited

	v.isForSale = data.isForSale
	v.remaining = data.remaining

	v.owned = data.owned

	if not v.collectibleIsLimited then
		v.isForSale = v.isForSale and not v.owned
	end

	v.description = data.description or ""
	v.productType = Constants.ProductType.CollectibleItem

	if data.price then
		v.price = data.price
	end

	return v
end

function AssetInfo.fromGetAssetFavoriteCount(p, numFavorites)
	local v = AssetInfo.new()

	v.assetId = tostring(p)
	v.numFavorites = numFavorites

	return v
end

function AssetInfo.fromGetEconomyProductInfo(p, owned, price, isForSale, premiumPricing)
	local v = AssetInfo.new()

	v.assetId = tostring(p.assetId)
	v.owned = owned

	if price then
		v.price = price
	end

	v.isForSale = isForSale
	v.premiumPricing = premiumPricing

	return v
end

function AssetInfo.fromGetItemDetailsV2(data)
	local v = AssetInfo.new()

	v.assetId = tostring(data.id)
	v.isForSale = data.isPurchasable
	v.price = data.price or 0
	v.hasResellers = data.hasResellers
	v.collectibleItemId = data.collectibleItemId

	local itemRestrictionSet = {}

	if data.itemRestrictions then
		for _, itemRestriction in data.itemRestrictions do
			itemRestrictionSet[itemRestriction] = true
		end

		v.itemRestrictions = itemRestrictionSet
	end

	v.saleLocationType = data.saleLocationType
	v.remaining = data.unitsAvailableForConsumption
	v.collectibleTotalQuantity = data.totalQuantity
	v.collectibleLowestResalePrice = data.lowestResalePrice
	v.isOffSale = data.isOffSale
	v.saleLocationType = data.saleLocationType
	v.numFavorites = data.favoriteCount
	v.catalogPriceStatus = data.priceStatus

	v.timedOptions = data.timedOptions
	local rawItemLicensingInfo = getRawItemLicensingInfo(data)

	if FFlagAXMarketplaceLicensing and rawItemLicensingInfo ~= nil then
		v.itemLicensingInfo = parseItemLicensing(rawItemLicensingInfo) or Cryo.None
	end

	return v
end

function AssetInfo.fromGetItemDetails(data)
	local v = AssetInfo.new()

	v.assetId = tostring(data.Id)
	v.owned = data.Owned
	v.isForSale = data.IsPurchasable
	v.price = data.Price or 0
	v.hasResellers = data.HasResellers
	v.collectibleItemId = data.CollectibleItemId

	local itemRestrictionSet = {}

	if data.ItemRestrictions then
		for _, itemRestriction in data.ItemRestrictions do
			itemRestrictionSet[itemRestriction] = true
		end

		v.itemRestrictions = itemRestrictionSet
	end

	v.saleLocationType = data.SaleLocationType
	v.remaining = data.UnitsAvailableForConsumption
	v.collectibleTotalQuantity = data.TotalQuantity
	v.collectibleLowestResalePrice = data.LowestResalePrice
	v.isOffSale = data.IsOffSale
	v.saleLocationType = data.SaleLocationType
	v.numFavorites = data.FavoriteCount
	v.catalogPriceStatus = data.PriceStatus

	v.creatingUniverseId = data.CreatingUniverseId

	return v
end

function AssetInfo.fromPurchaseSuccess(p)
	local v = AssetInfo.new()
	v.assetId = tostring(p)
	v.owned = true
	return v
end

function AssetInfo.fromGetVersionInfo(p, p2)
	local v = AssetInfo.new()

	v.assetId = tostring(p)
	local creatingUniverseId

	if p2.creatingUniverseId then
		creatingUniverseId = tostring(p2.creatingUniverseId)
	end

	v.creatingUniverseId = creatingUniverseId

	return v
end

function AssetInfo.getSaleDetailsForCollectibles(data)
	local saleDetailsForCollectibles = Dash.joinDeep({}, data)
	local saleLocation = data.saleLocation

	if data.productType == Constants.ProductType.CollectibleItem then
		local v = saleLocation and saleLocation.SaleLocationType ~= Constants.SaleLocationType.ShopOnly

		local v2 = saleLocation and saleLocation.SaleLocationType ~= Constants.SaleLocationType.ShopAndExperiencesById
		local v3

		if saleLocation then
			if
				saleLocation.SaleLocationType == Constants.SaleLocationType.ShopAndExperiencesById
				and type(saleLocation.UniverseIds) == "table"
			then
				v3 = table.find(saleLocation.UniverseIds, game.GameId) ~= nil
			else
				v3 = false
			end
		else
			v3 = saleLocation
		end

		local v4 = saleLocation and saleLocation.SaleLocationType ~= Constants.SaleLocationType.ExperiencesDevApiOnly

		local isForSale = data.isForSale and data.canBeSoldInThisGame

		if isForSale then
			if v then
				isForSale = if v2 or v3 then v4 else v3
			else
				isForSale = v
			end
		end

		saleDetailsForCollectibles.isForSale = isForSale

		if not data.collectibleIsLimited then
			saleDetailsForCollectibles.isForSale = saleDetailsForCollectibles.isForSale
				and not saleDetailsForCollectibles.owned
			return saleDetailsForCollectibles
		end
	else
		saleDetailsForCollectibles.isForSale = data.isForSale and data.canBeSoldInThisGame

		if data.canBeSoldInThisGame == nil then
			saleDetailsForCollectibles.isForSale = data.isForSale
		end
	end

	return saleDetailsForCollectibles
end

return AssetInfo
