require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/AssetInfo")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CatalogNetworking")
local AvatarExperienceInspectAndBuy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceInspectAndBuy")
local getPriceStatusInShop = AvatarExperienceInspectAndBuy.Utils.getPriceStatusInShop
local priceStatus = AvatarExperienceInspectAndBuy.Enums.PriceStatus
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local salesLocationType = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceCommon").Enums.SalesLocationType

local v5 = {
	[61] = true,
	[60] = true,
	[55] = true,
	[56] = true,
	[57] = true,
	[58] = true,
	[59] = true,
	[48] = true,
	[9] = true
}

local set = {}

for k, v6 in Enum.AvatarAssetType:GetEnumItems() do
	if not v5[v6.Value] then
		set[v6.Value] = true
	end
end

local function getPriceStatusForProfile(p2)
	return getPriceStatusInShop(p2)
end

local function normalizeSaleLocationType(p2)
	if p2.saleLocationType == salesLocationType.ShopOnly then
		return salesLocationType.ShopAndAllExperiences
	end

	return p2.saleLocationType
end

local function resolveIsOwned(p2, p3, p4)
	if p3 and p3.quantityOwned ~= nil then
		return p3.quantityOwned > 0
	end

	if p4 == nil then
		return p2.owned == true
	end

	return p4
end

local function buildItemRestrictions(p2)
	local itemRestrictions = p2.itemRestrictions

	if not itemRestrictions or #itemRestrictions == 0 then
		return nil
	end

	local itemRestrictionSet = {}

	for k, itemRestriction in itemRestrictions do
		itemRestrictionSet[itemRestriction] = true
	end

	return itemRestrictionSet
end

local function buildCollectibleItemDetails(data, data2, collectibleLowestAvailableResaleProductId)
	local collectibleItemDetails

	if
		data.hasResellers
		or data.unitsAvailableForConsumption
		or data.totalQuantity
		or data.lowestResalePrice
		or data2 and data2.quantityOwned
	then
		collectibleItemDetails = {
			hasResellers = data.hasResellers,
			unitsAvailableForConsumption = data.unitsAvailableForConsumption,
			totalQuantity = data.totalQuantity,
			lowestResalePrice = data.lowestResalePrice,
			resellableCount = 0,
			collectibleLowestAvailableResaleProductId = 0
		}
		local v6 = if data2 then data2.quantityOwned else nil
		collectibleItemDetails.resellableCount = v6
		collectibleItemDetails.collectibleLowestAvailableResaleProductId = collectibleLowestAvailableResaleProductId
	end

	return collectibleItemDetails
end

local function buildAssetsInBundle(data, data2)
	local v6 = nil

	if data2 and data2.assetsInBundle then
		local result = {}

		for k, v7 in data2.assetsInBundle do
			table.insert(result, {
				id = tostring(v7.id),
				assetType = tostring(v7.assetType),
				isIncluded = v7.isIncluded
			})
		end

		return result
	else
		if not data.bundledItems then
			return v6
		end

		local v7 = {}

		for k, bundledItem in data.bundledItems do
			if bundledItem.type == "Asset" and bundledItem.assetType then
				table.insert(v7, {
					id = tostring(bundledItem.id),
					assetType = tostring(bundledItem.assetType)
				})
			end
		end

		if #v7 > 0 then
			v6 = v7
		end

		return v6
	end
end

local function computeBundleParts(data, data2, p2)
	local count = 0
	local ids = {}

	if data2 and data2.assetsInBundle then
		for k, v6 in data2.assetsInBundle do
			if not p2[tostring(v6.id)] then
				continue
			end

			count += 1

			if set[v6.assetType] == true then
				table.insert(ids, v6.id)
			end
		end
	elseif data.bundledItems then
		for k, bundledItem in data.bundledItems do
			if bundledItem.type ~= "Asset" then
				continue
			end

			count += 1

			if bundledItem.assetType and set[bundledItem.assetType] == true then
				table.insert(ids, bundledItem.id)
			end
		end
	end

	return count, ids
end

local function extractTaxonomyName(p2)
	if p2.taxonomy and #p2.taxonomy > 0 then
		return p2.taxonomy[1].taxonomyName
	end

	return nil
end

return {
	isWearableAssetType = function(p2): boolean
		return set[p2] == true
	end,
	expandBundleToAssetIds = function(p2)
		local ids = {}

		if p2.bundledItems then
			for k, bundledItem in p2.bundledItems do
				if bundledItem.type == "Asset" then
					table.insert(ids, bundledItem.id)
				end
			end
		end

		return ids
	end,
	collectBundleComponentIds = function(items, p2)
		local idSet = {}

		for k, item in items do
			local v6 = p2[item]

			if not (v6 and v6.assetsInBundle) then
				continue
			end

			for k2, v7 in v6.assetsInBundle do
				idSet[tostring(v7.id)] = true
			end
		end

		return idSet
	end,
	buildItemData = function(data, data2, p2, collectibleProductId, isOwned, p3)
		local assetType = data.assetType or data.bundleType
		local v6, v7 = computeBundleParts(data, data2, p2)
		local itemType = data.itemType or "Asset"

		local itemData = {
			id = tostring(data.id),
			name = data.name,
			itemType = itemType,
			itemSubType = 0,
			priceInRobux = 0,
			creator = 0,
			saleLocationType = 0,
			isOffSale = 0,
			isOwned = 0,
			noPriceStatus = 0,
			catalogPriceStatus = 0,
			collectibleItemId = 0,
			itemRestrictions = 0,
			collectibleItemDetails = 0,
			assetsInBundle = 0,
			collectibleProductId = 0,
			bundlePartsCount = 0,
			bundleAssetIds = 0,
			taxonomyName = 0
		}

		local v8 = if assetType then tostring(assetType) else nil
		itemData.itemSubType = v8
		itemData.priceInRobux = data.price
		itemData.creator = {
			creatorId = tostring(data.creatorTargetId or ""),
			creatorName = data.creatorName,
			creatorHasVerifiedBadge = data.creatorHasVerifiedBadge
		}
		local v9 = if data.saleLocationType == salesLocationType.ShopOnly then salesLocationType.ShopAndAllExperiences else data.saleLocationType

		itemData.saleLocationType = v9
		itemData.isOffSale = data.isOffSale

		if data2 and data2.quantityOwned ~= nil then
			isOwned = data2.quantityOwned > 0
		elseif isOwned == nil then
			isOwned = data.owned == true
		end

		itemData.isOwned = isOwned
		local v10 = if data2 then data2.noPriceStatus else nil
		itemData.noPriceStatus = v10
		itemData.catalogPriceStatus = data.priceStatus
		itemData.collectibleItemId = data.collectibleItemId
		local itemRestrictions = data.itemRestrictions
		local itemRestrictionSet

		if itemRestrictions and #itemRestrictions ~= 0 then
			itemRestrictionSet = {}

			for k, itemRestriction in itemRestrictions do
				itemRestrictionSet[itemRestriction] = true
			end
		end

		itemData.itemRestrictions = itemRestrictionSet
		itemData.collectibleItemDetails = buildCollectibleItemDetails(data, data2, p3)
		itemData.assetsInBundle = buildAssetsInBundle(data, data2)

		if data2 then
			collectibleProductId = data2.collectibleProductId
		end

		itemData.collectibleProductId = collectibleProductId
		itemData.bundlePartsCount = v6
		itemData.bundleAssetIds = v7
		local v11 = if data.taxonomy and #data.taxonomy > 0 then data.taxonomy[1].taxonomyName else nil

		itemData.taxonomyName = v11
		return itemData
	end,
	isPurchasableStatus = function(p2): boolean
		return p2 == priceStatus.Free
			or p2 == priceStatus.PurchaseFromRoblox
			or p2 == priceStatus.PurchaseFromResale
	end,
	isItemPurchasable = function(p2): boolean
		if p2.isOwned then
			return false
		end

		local priceStatusInShop = getPriceStatusInShop(p2)

		return (priceStatusInShop == priceStatus.Free or priceStatusInShop == priceStatus.PurchaseFromRoblox or priceStatusInShop == priceStatus.PurchaseFromResale)
			and p2.collectibleProductId ~= nil
	end,
	getEffectivePrice = function(p2)
		if getPriceStatusInShop(p2) ~= priceStatus.PurchaseFromResale then
			return p2.priceInRobux or 0
		end

		if p2.collectibleItemDetails then
			return p2.collectibleItemDetails.lowestResalePrice or 0
		end

		return 0
	end,
	sortDisplayItems = function(list)
		table.sort(list, function(a, b): boolean
			local function sortKey(p2): number
				local priceStatusInShop = getPriceStatusInShop(p2)

				if
					priceStatusInShop == priceStatus.Free
					or priceStatusInShop == priceStatus.PurchaseFromRoblox
					or priceStatusInShop == priceStatus.PurchaseFromResale
				then
					return 0
				end

				if
					priceStatusInShop == priceStatus.Owned
					or priceStatusInShop == priceStatus.QuantityLimitReached
				then
					return 1
				end

				return 2
			end

			local priceStatusInShop = getPriceStatusInShop(a)

			local v6 = (priceStatusInShop == priceStatus.Free or priceStatusInShop == priceStatus.PurchaseFromRoblox or priceStatusInShop == priceStatus.PurchaseFromResale)
				and 0
				or (priceStatusInShop == priceStatus.Owned or priceStatusInShop == priceStatus.QuantityLimitReached)
				and 1
				or 2
			local priceStatusInShop2 = getPriceStatusInShop(b)

			return v6 < ((priceStatusInShop2 == priceStatus.Free or priceStatusInShop2 == priceStatus.PurchaseFromRoblox or priceStatusInShop2 == priceStatus.PurchaseFromResale) and 0 or (priceStatusInShop2 == priceStatus.Owned or priceStatusInShop2 == priceStatus.QuantityLimitReached) and 1 or 2)
		end)

		return list
	end,
	getPriceStatus = getPriceStatusForProfile,
	PriceStatusEnum = priceStatus
}
