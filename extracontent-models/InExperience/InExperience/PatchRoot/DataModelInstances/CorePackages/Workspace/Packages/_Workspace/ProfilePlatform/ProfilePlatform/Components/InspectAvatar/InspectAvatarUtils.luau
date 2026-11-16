local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

require(ProfilePlatform.Common.AssetInfo)
require(parent.CatalogNetworking)
local AvatarExperienceInspectAndBuy = require(parent.AvatarExperienceInspectAndBuy)
local getPriceStatusInShop = AvatarExperienceInspectAndBuy.Utils.getPriceStatusInShop
local PriceStatus = AvatarExperienceInspectAndBuy.Enums.PriceStatus
require(ProfilePlatform.Common.Types)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local SalesLocationType = AvatarExperienceCommon.Enums.SalesLocationType

local v = {
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

for _, v2 in Enum.AvatarAssetType:GetEnumItems() do
	if not v[v2.Value] then
		set[v2.Value] = true
	end
end

local function getPriceStatusForProfile(p) -- 3 equivalent calls inferred from this helper
	return getPriceStatusInShop(p)
end

local function isWearableAssetType(assetType: number): boolean -- 2 equivalent calls inferred from this helper
	return set[assetType] == true
end

local function isPurchasableStatus(p: string): boolean -- 4 equivalent calls inferred from this helper
	return p == PriceStatus.Free or p == PriceStatus.PurchaseFromRoblox or p == PriceStatus.PurchaseFromResale
end

local function normalizeSaleLocationType(data) -- 1 equivalent call inferred from this helper
	if data.saleLocationType == SalesLocationType.ShopOnly then
		return SalesLocationType.ShopAndAllExperiences
	end

	return data.saleLocationType
end

local function resolveIsOwned(data, p, isOwned: boolean?) -- 1 equivalent call inferred from this helper
	if p and p.quantityOwned ~= nil then
		return p.quantityOwned > 0
	end

	if isOwned == nil then
		return data.owned == true
	end

	return isOwned
end

local function buildItemRestrictions(data) -- 1 equivalent call inferred from this helper
	local itemRestrictions = data.itemRestrictions

	if not itemRestrictions or #itemRestrictions == 0 then
		return nil
	end

	local itemRestrictionSet = {}

	for _, itemRestriction in itemRestrictions do
		itemRestrictionSet[itemRestriction] = true
	end

	return itemRestrictionSet
end

local function buildCollectibleItemDetails(data, p, collectibleLowestAvailableResaleProductId: string?)
	local collectibleItemDetails

	if
		data.hasResellers
		or data.unitsAvailableForConsumption
		or data.totalQuantity
		or data.lowestResalePrice
		or p and p.quantityOwned
	then
		collectibleItemDetails = {
			hasResellers = data.hasResellers,
			unitsAvailableForConsumption = data.unitsAvailableForConsumption,
			totalQuantity = data.totalQuantity,
			lowestResalePrice = data.lowestResalePrice,
			resellableCount = 0,
			collectibleLowestAvailableResaleProductId = 0
		}
		local resellableCount

		if p then
			resellableCount = p.quantityOwned
		end

		collectibleItemDetails.resellableCount = resellableCount
		collectibleItemDetails.collectibleLowestAvailableResaleProductId = collectibleLowestAvailableResaleProductId
	end

	return collectibleItemDetails
end

local function buildAssetsInBundle(data, p)
	local v2 = nil

	if p and p.assetsInBundle then
		local result = {}

		for _, v3 in p.assetsInBundle do
			table.insert(result, {
				id = tostring(v3.id),
				assetType = tostring(v3.assetType),
				isIncluded = v3.isIncluded
			})
		end

		return result
	else
		if not data.bundledItems then
			return v2
		end

		local v3 = {}

		for _, bundledItem in data.bundledItems do
			if bundledItem.type == "Asset" and bundledItem.assetType then
				table.insert(v3, {
					id = tostring(bundledItem.id),
					assetType = tostring(bundledItem.assetType)
				})
			end
		end

		return if #v3 > 0 then v3 else v2
	end
end

local function computeBundleParts(data, p, p2)
	local count = 0
	local ids = {}

	if p and p.assetsInBundle then
		for _, v2 in p.assetsInBundle do
			if not p2[tostring(v2.id)] then
				continue
			end

			count += 1

			if isWearableAssetType(v2.assetType) then -- inferred equivalent call
				table.insert(ids, v2.id)
			end
		end
	elseif data.bundledItems then
		for _, bundledItem in data.bundledItems do
			if bundledItem.type ~= "Asset" then
				continue
			end

			count += 1

			if bundledItem.assetType and isWearableAssetType(bundledItem.assetType) then -- inferred equivalent call
				table.insert(ids, bundledItem.id)
			end
		end
	end

	return count, ids
end

local function extractTaxonomyName(data) -- 1 equivalent call inferred from this helper
	if data.taxonomy and #data.taxonomy > 0 then
		return data.taxonomy[1].taxonomyName
	end

	return nil
end

local InspectAvatarUtils = {}
InspectAvatarUtils.isWearableAssetType = isWearableAssetType

function InspectAvatarUtils.expandBundleToAssetIds(p)
	local ids = {}

	if p.bundledItems then
		for _, bundledItem in p.bundledItems do
			if bundledItem.type == "Asset" then
				table.insert(ids, bundledItem.id)
			end
		end
	end

	return ids
end

function InspectAvatarUtils.collectBundleComponentIds(items, p)
	local idSet = {}

	for _, item in items do
		local v2 = p[item]

		if not (v2 and v2.assetsInBundle) then
			continue
		end

		for _, v3 in v2.assetsInBundle do
			idSet[tostring(v3.id)] = true
		end
	end

	return idSet
end

function InspectAvatarUtils.buildItemData(data, p, p2, collectibleProductId: string?, isOwned: boolean?, collectibleLowestAvailableResaleProductId: string?)
	local assetType = data.assetType or data.bundleType
	local bundlePartsCount, bundleAssetIds = computeBundleParts(data, p, p2)
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
	local itemSubType

	if assetType then
		itemSubType = tostring(assetType)
	end

	itemData.itemSubType = itemSubType
	itemData.priceInRobux = data.price
	itemData.creator = {
		creatorId = tostring(data.creatorTargetId or ""),
		creatorName = data.creatorName,
		creatorHasVerifiedBadge = data.creatorHasVerifiedBadge
	}
	itemData.saleLocationType = normalizeSaleLocationType(data) -- inferred equivalent call
	itemData.isOffSale = data.isOffSale
	isOwned = resolveIsOwned(data, p, isOwned) -- inferred equivalent call
	itemData.isOwned = isOwned
	local noPriceStatus

	if p then
		noPriceStatus = p.noPriceStatus
	end

	itemData.noPriceStatus = noPriceStatus
	itemData.catalogPriceStatus = data.priceStatus
	itemData.collectibleItemId = data.collectibleItemId
	itemData.itemRestrictions = buildItemRestrictions(data) -- inferred equivalent call
	itemData.collectibleItemDetails = buildCollectibleItemDetails(data, p, collectibleLowestAvailableResaleProductId)
	itemData.assetsInBundle = buildAssetsInBundle(data, p)

	if p then
		collectibleProductId = p.collectibleProductId
	end

	itemData.collectibleProductId = collectibleProductId
	itemData.bundlePartsCount = bundlePartsCount
	itemData.bundleAssetIds = bundleAssetIds
	itemData.taxonomyName = extractTaxonomyName(data) -- inferred equivalent call
	return itemData
end

InspectAvatarUtils.isPurchasableStatus = isPurchasableStatus

function InspectAvatarUtils.isItemPurchasable(p)
	return not p.isOwned and isPurchasableStatus(getPriceStatusForProfile(p)) and p.collectibleProductId ~= nil -- inferred equivalent call
end

function InspectAvatarUtils.getEffectivePrice(p)
	if getPriceStatusForProfile(p) ~= PriceStatus.PurchaseFromResale then -- inferred equivalent call
		return p.priceInRobux or 0
	end

	if p.collectibleItemDetails then
		return p.collectibleItemDetails.lowestResalePrice or 0
	end

	return 0
end

function InspectAvatarUtils.sortDisplayItems(list)
	table.sort(list, function(a, b): boolean
		local function sortKey(p): number
			local priceStatusForProfile = getPriceStatusForProfile(p) -- inferred equivalent call

			if isPurchasableStatus(priceStatusForProfile) then -- inferred equivalent call
				return 0
			end

			if
				priceStatusForProfile == PriceStatus.Owned
				or priceStatusForProfile == PriceStatus.QuantityLimitReached
			then
				return 1
			end

			return 2
		end

		local priceStatusInShop = getPriceStatusInShop(a)

		local v2 = isPurchasableStatus(priceStatusInShop) and 0 -- inferred equivalent call
			or (priceStatusInShop == PriceStatus.Owned or priceStatusInShop == PriceStatus.QuantityLimitReached) and 1
			or 2
		local priceStatusInShop2 = getPriceStatusInShop(b)

		return v2 < (isPurchasableStatus(priceStatusInShop2) and 0 or (priceStatusInShop2 == PriceStatus.Owned or priceStatusInShop2 == PriceStatus.QuantityLimitReached) and 1 or 2) -- inferred equivalent call
	end)

	return list
end

InspectAvatarUtils.getPriceStatus = getPriceStatusForProfile
InspectAvatarUtils.PriceStatusEnum = PriceStatus
return InspectAvatarUtils
