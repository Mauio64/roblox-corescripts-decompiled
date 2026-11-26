local CorePackages = game:GetService("CorePackages")

require("@luauforge/bundled/dPs")
local module = require("@luauforge/bundled/dPN")
local t = require(CorePackages.Packages.t)
local module2 = require("@luauforge/bundled/dPU")
local UIBlox = require(CorePackages.Packages.UIBlox)
local itemTileEnums = UIBlox.Tile.ItemTileEnums
local module3 = require("@luauforge/bundled/fCe")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize

local v6 = memoize(function(list)
	if not (list and #list ~= 0) then
		return nil, nil
	end

	local set = {}

	for k, item in list do
		set[item] = true
	end

	local info = nil
	local new = nil

	if set[module2.ItemStatus.Sale] then
		return itemTileEnums.StatusStyle.Alert, module2.ItemStatusLocale.Sale
	end

	if set[module2.ItemStatus.New] then
		info = itemTileEnums.StatusStyle.Info
		new = module2.ItemStatusLocale.New
	end

	return info, new
end)

local v7 = memoize(function(p2): nil | boolean
	if not p2 then
		return nil
	end

	if p2[module2.ItemRestrictions.Limited] or p2[module2.ItemRestrictions.LimitedUnique] then
		return true
	end

	if p2[module2.ItemRestrictions.Collectible] then
		return false
	end

	return nil
end)

local v8 = memoize(function(p2, p3)
	local v9 = p3 and p3[module2.ItemRestrictions.Limited]
	local v10 = p3 and p3[module2.ItemRestrictions.LimitedUnique]
	local v11 = p3 and p3[module2.ItemRestrictions.Collectible]

	return v9 or v11 or v10 and p2 and p2 == 0
end)

local v9 = memoize(function(p2, p3): boolean
	if p2 then
		return p2[module2.ItemRestrictions.Collectible] ~= nil
	end

	return false
end)
return {
	["fromOutfitInfo"] = memoize(function(data)
		local v10 = {}

		for k, asset in data.assets do
			for k2, v11 in asset do
				table.insert(v10, { id = k2, type = module.ItemType.Asset })
			end
		end

		return {
			itemType = module.ItemType.Outfit,
			itemId = data.outfitId,
			name = data.name,
			hasPremiumBenefits = false,
			isPremiumExclusive = false,
			isEditable = data.isEditable,
			hasAttribution = data.creatingUniverseId and true or false,
			updateCounter = data.updateCounter,
			itemSubType = data.outfitType,
			itemIconType = module3.getItemIconTypeFromOutfit(data),
			includedItems = v10,
			outfitInfo = data
		}
	end),
	fromAssetInfo = memoize(function(data)
		local v10, v11 = v6(data.itemStatus)
		local v12 = v9(data.itemRestrictions, data.collectibleItemId)

		return {
			itemType = module.ItemType.Asset,
			itemId = data.id,
			name = data.name,
			description = data.description,
			isEditable = false,
			itemSubType = data.assetType,
			priceInRobux = data.priceInRobux,
			priceStatus = data.priceStatus,
			productId = data.product and data.product.id,
			collectibleItemId = data.collectibleItemId,
			statusStyle = v10,
			statusText = v11,
			resellerUserAssetIds = data.resellerUserAssetIds,
			receivedCatalogData = data.receivedCatalogData,
			lowestPrice = data.lowestPrice,
			isOwned = data.isOwned,
			isTradeable = v7(data.itemRestrictions),
			isResellable = v8(data.numberRobloxHasAvailable, data.itemRestrictions),
			hasAttribution = data.creatingUniverseId and true or false,
			expectedSellerId = data.expectedSellerId,
			creator = data.creator,
			receivedRecommendedData = data.receivedRecommendedData,
			recommendedItemSummaries = data.recommendedItemSummaries,
			favoriteCount = data.favoriteCount,
			soldCount = data.soldCount,
			totalQuantity = data.totalQuantity,
			originalPrice = data.originalPrice,
			averagePrice = data.averagePrice,
			creatingUniverseId = data.creatingUniverseId,
			isForRent = data.isForRent,
			isPurchasable = data.isPurchasable,
			isLimitedCollectible = v12,
			assetInfo = data
		}
	end),
	fromBundleInfo = memoize(function(data)
		local v10, v11 = v6(data.itemStatus)

		local collectibleItemId = data.collectibleItemId
		local v12 = v9(data.itemRestrictions, data.collectibleItemId)

		return {
			itemType = module.ItemType.Bundle,
			itemId = data.id,
			name = data.name,
			description = data.description,
			hasPremiumBenefits = false,
			isPremiumExclusive = false,
			isEditable = false,
			itemSubType = data.bundleType,
			priceInRobux = data.priceInRobux,
			priceStatus = data.priceStatus,
			productId = data.product and data.product.id,
			statusStyle = v10,
			statusText = v11,
			receivedCatalogData = data.receivedCatalogData,
			lowestPrice = data.lowestPrice,
			isOwned = data.isOwned,
			isTradeable = v7(data.itemRestrictions),
			isResellable = v8(data.numberRobloxHasAvailable, data.itemRestrictions),
			itemIconType = itemTileEnums.ItemIconType.Bundle,
			expectedSellerId = data.expectedSellerId,
			creator = data.creator,
			receivedRecommendedData = data.receivedRecommendedData,
			recommendedItemSummaries = data.recommendedItemSummaries,
			favoriteCount = data.favoriteCount,
			includedItems = data.items,
			isForRent = data.isForRent,
			isPurchasable = data.isPurchasable,
			collectibleItemId = collectibleItemId,
			isLimitedCollectible = v12,
			bundleInfo = data
		}
	end),
	Validator = t.strictInterface({
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
}
