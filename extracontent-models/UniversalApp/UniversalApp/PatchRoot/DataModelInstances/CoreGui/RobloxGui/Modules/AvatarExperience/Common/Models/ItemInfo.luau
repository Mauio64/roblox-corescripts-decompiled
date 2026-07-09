local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local t = require(CorePackages.Packages.t)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local ItemTileEnums = require(CorePackages.Packages.UIBlox).Tile.ItemTileEnums
local Utils = require(Modules.AvatarExperience.Common.Utils)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local t1 = {}
local v11 = memoize(function(p1) -- line: 21
	-- upvalues: CatalogConstants (copy), ItemTileEnums (copy)
	if not p1 then
		return nil, nil
	end

	if #p1 == 0 then
		return nil, nil
	end

	local t2 = {}

	for _, v18 in p1 do
		t2[v18] = true
	end

	local Info = nil
	local New = nil

	if t2[CatalogConstants.ItemStatus.Sale] then
		return ItemTileEnums.StatusStyle.Alert, CatalogConstants.ItemStatusLocale.Sale
	end

	if t2[CatalogConstants.ItemStatus.New] then
		Info = ItemTileEnums.StatusStyle.Info
		New = CatalogConstants.ItemStatusLocale.New
	end

	return Info, New
end)
local v12 = memoize(function(p2) -- line: 47
	-- upvalues: CatalogConstants (copy)
	if not p2 then
		return nil
	end

	if p2[CatalogConstants.ItemRestrictions.Limited] then
		return true
	end

	if p2[CatalogConstants.ItemRestrictions.LimitedUnique] then
		return true
	end

	if p2[CatalogConstants.ItemRestrictions.Collectible] then
		return false
	end

	return nil
end)
local v13 = memoize(function(p3, p4) -- line: 61
	-- upvalues: CatalogConstants (copy)
	local v24 = p4 and p4[CatalogConstants.ItemRestrictions.Limited]
	local v25 = p4 and p4[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v26 = p4 and p4[CatalogConstants.ItemRestrictions.Collectible]

	return v24 or (v26 or v25 and (p3 and p3 == 0))
end)
local v14 = memoize(function(t3: {[any]: any}?, _) -- line: 71
	-- upvalues: CatalogConstants (copy)
	if t3 then
		return t3[CatalogConstants.ItemRestrictions.Collectible] ~= nil
	end

	return false
end)

t1.fromOutfitInfo = memoize(function(p6) -- line: 78
	-- upvalues: Constants (copy), Utils (copy)
	local t4 = {}

	for _, v32 in p6.assets do
		for v33, _ in v32 do
			table.insert(t4, {
				id = v33,
				type = Constants.ItemType.Asset
			})
		end
	end

	return {
		hasPremiumBenefits = false,
		isPremiumExclusive = false,
		itemType = Constants.ItemType.Outfit,
		itemId = p6.outfitId,
		name = p6.name,
		isEditable = p6.isEditable,
		hasAttribution = not not p6.creatingUniverseId,
		updateCounter = p6.updateCounter,
		itemSubType = p6.outfitType,
		itemIconType = Utils.getItemIconTypeFromOutfit(p6),
		includedItems = t4,
		outfitInfo = p6
	}
end)
t1.fromAssetInfo = memoize(function(p7) -- line: 110
	-- upvalues: v11 (copy), v14 (copy), Constants (copy), v12 (copy), v13 (copy)
	local v36, v37 = v11(p7.itemStatus)
	local v38 = v14(p7.itemRestrictions, p7.collectibleItemId)

	return {
		itemType = Constants.ItemType.Asset,
		itemId = p7.id,
		name = p7.name,
		description = p7.description,
		isEditable = false,
		itemSubType = p7.assetType,
		priceInRobux = p7.priceInRobux,
		priceStatus = p7.priceStatus,
		productId = p7.product and p7.product.id,
		collectibleItemId = p7.collectibleItemId,
		statusStyle = v36,
		statusText = v37,
		resellerUserAssetIds = p7.resellerUserAssetIds,
		receivedCatalogData = p7.receivedCatalogData,
		lowestPrice = p7.lowestPrice,
		isOwned = p7.isOwned,
		isTradeable = v12(p7.itemRestrictions),
		isResellable = v13(p7.numberRobloxHasAvailable, p7.itemRestrictions),
		hasAttribution = not not p7.creatingUniverseId,
		expectedSellerId = p7.expectedSellerId,
		creator = p7.creator,
		receivedRecommendedData = p7.receivedRecommendedData,
		recommendedItemSummaries = p7.recommendedItemSummaries,
		favoriteCount = p7.favoriteCount,
		soldCount = p7.soldCount,
		totalQuantity = p7.totalQuantity,
		originalPrice = p7.originalPrice,
		averagePrice = p7.averagePrice,
		creatingUniverseId = p7.creatingUniverseId,
		isForRent = p7.isForRent,
		isPurchasable = p7.isPurchasable,
		isLimitedCollectible = v38,
		assetInfo = p7
	}
end)
t1.fromBundleInfo = memoize(function(p8) -- line: 154
	-- upvalues: v11 (copy), v14 (copy), Constants (copy), v12 (copy), v13 (copy), ItemTileEnums (copy)
	local v40, v41 = v11(p8.itemStatus)
	local collectibleItemId = p8.collectibleItemId
	local v43 = v14(p8.itemRestrictions, p8.collectibleItemId)

	return {
		hasPremiumBenefits = false,
		isPremiumExclusive = false,
		isEditable = false,
		itemType = Constants.ItemType.Bundle,
		itemId = p8.id,
		name = p8.name,
		description = p8.description,
		itemSubType = p8.bundleType,
		priceInRobux = p8.priceInRobux,
		priceStatus = p8.priceStatus,
		productId = p8.product and p8.product.id,
		statusStyle = v40,
		statusText = v41,
		receivedCatalogData = p8.receivedCatalogData,
		lowestPrice = p8.lowestPrice,
		isOwned = p8.isOwned,
		isTradeable = v12(p8.itemRestrictions),
		isResellable = v13(p8.numberRobloxHasAvailable, p8.itemRestrictions),
		itemIconType = ItemTileEnums.ItemIconType.Bundle,
		expectedSellerId = p8.expectedSellerId,
		creator = p8.creator,
		receivedRecommendedData = p8.receivedRecommendedData,
		recommendedItemSummaries = p8.recommendedItemSummaries,
		favoriteCount = p8.favoriteCount,
		includedItems = p8.items,
		isForRent = p8.isForRent,
		isPurchasable = p8.isPurchasable,
		collectibleItemId = collectibleItemId,
		isLimitedCollectible = v43,
		bundleInfo = p8
	}
end)
t1.Validator = t.strictInterface({
	itemType = t.string,
	itemId = t.optional(t.string),
	name = t.optional(t.string),
	description = t.optional(t.string),
	itemSubType = t.optional(t.string),
	priceInRobux = t.optional(t.number),
	priceStatus = t.optional(t.string),
	productId = t.optional(t.string),
	collectibleItemId = t.optional(t.string),
	statusStyle = t.optional(t.string),
	statusText = t.optional(t.string),
	resellerUserAssetIds = t.optional(t.table),
	lowestPrice = t.optional(t.number),
	premiumPricing = t.optional(t.table),
	tileRestrictionsMap = t.optional(t.table),
	updateCounter = t.optional(t.number),
	itemIconType = t.optional(t.userdata),
	expectedSellerId = t.optional(t.string),
	creator = t.optional(t.table),
	recommendedItemSummaries = t.optional(t.table),
	favoriteCount = t.optional(t.number),
	includedItems = t.optional(t.table),
	soldCount = t.optional(t.number),
	totalQuantity = t.optional(t.number),
	originalPrice = t.optional(t.number),
	averagePrice = t.optional(t.number),
	creatingUniverseId = t.optional(t.string),
	hasAttribution = t.optional(t.boolean),
	hasPremiumBenefits = t.optional(t.boolean),
	isEditable = t.optional(t.boolean),
	isForRent = t.optional(t.boolean),
	isLimitedCollectible = t.optional(t.boolean),
	isLimitedBundle = t.optional(t.boolean),
	isOwned = t.optional(t.boolean),
	isPremiumExclusive = t.optional(t.boolean),
	isPurchasable = t.optional(t.boolean),
	isResellable = t.optional(t.boolean),
	isTradeable = t.optional(t.boolean),
	receivedCatalogData = t.optional(t.boolean),
	receivedRecommendedData = t.optional(t.boolean),
	assetInfo = t.optional(t.table),
	bundleInfo = t.optional(t.table),
	outfitInfo = t.optional(t.table)
})

return t1
