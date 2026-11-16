local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
require(AvatarExperienceInspectAndBuy.Types)
require(parent.AXCommon)
require(parent.AvatarExperienceRodux)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local tutils = require(parent.tutils)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local function buildCollectibleItemDetails(p, data)
	local collectibles = p.Collectibles
	local collectibleItemId = data.collectibleItemId
	local v

	if collectibles and collectibleItemId and collectibles.CollectiblesItemInfo then
		v = collectibles.CollectiblesItemInfo[collectibleItemId]
	end

	local v2

	if collectibles and collectibleItemId and collectibles.CollectiblesResellableInstances then
		v2 = collectibles.CollectiblesResellableInstances[collectibleItemId]
	end

	local resellableCount = not v2 and 0 or tutils.fieldCount(v2)
	local lowestAvailableResaleProductId

	if v then
		lowestAvailableResaleProductId = v.lowestAvailableResaleProductId
	end

	local quantityLimitPerUser

	if v then
		quantityLimitPerUser = v.quantityLimitPerUser
	end

	local collectibleProductId

	if v then
		collectibleProductId = v.collectibleProductId
	end

	local collectibleLowestAvailableResaleItemInstanceId

	if v then
		collectibleLowestAvailableResaleItemInstanceId = v.lowestAvailableResaleItemInstanceId
	end

	local v3

	if v then
		v3 = v.unitsAvailableForConsumption
	end

	local collectibleItemDetails = {
		quantityLimitPerUser = quantityLimitPerUser,
		resellableCount = resellableCount,
		collectibleProductId = collectibleProductId,
		collectibleLowestAvailableResaleProductId = lowestAvailableResaleProductId,
		collectibleLowestAvailableResaleItemInstanceId = collectibleLowestAvailableResaleItemInstanceId,
		unitsAvailableForConsumption = v3 or data.numberRobloxHasAvailable,
		hasResellers = 0,
		lowestResalePrice = 0,
		totalQuantity = 0,
		experiences = 0
	}

	local hasResellers = data.hasResellers

	if not hasResellers then
		local v4

		if v then
			v4 = v.hasResellers
		end

		hasResellers = v4 or lowestAvailableResaleProductId ~= nil and lowestAvailableResaleProductId ~= ""
	end

	collectibleItemDetails.hasResellers = hasResellers

	collectibleItemDetails.lowestResalePrice = data.lowestResalePrice
	collectibleItemDetails.totalQuantity = data.totalQuantity
	local experiences = data.experiences

	if not experiences then
		experiences = if v then v.experiences else nil
	end

	collectibleItemDetails.experiences = experiences
	return collectibleItemDetails
end

local function buildAssetsInBundle(items)
	if not items then
		return nil
	end

	local result = {}

	for _, item in items do
		local v = { id = tostring(item.id), assetType = 0 }
		local assetType

		if item.assetType ~= nil then
			assetType = tostring(item.assetType)
		end

		v.assetType = assetType
		table.insert(result, v)
	end

	return result
end

local function buildItemDataFromAXRodux(p, id: string, itemType)
	if not p then
		return nil
	end

	local v = nil

	if itemType == ItemTypeEnum.Asset then
		if p.AssetInfos then
			v = p.AssetInfos[id]
		end
	elseif itemType == ItemTypeEnum.Bundle and p.BundleInfos then
		v = p.BundleInfos[id]
	end

	if not v then
		return nil
	end

	local creator = v.creator

	local v2 = {
		id = id,
		name = v.name,
		description = v.description,
		itemType = itemType,
		itemSubType = 0,
		creator = 0,
		creatingUniverseId = 0,
		saleLocationType = 0,
		itemRestrictions = 0,
		priceInRobux = 0,
		discountInformation = 0,
		catalogPriceStatus = 0,
		isOwned = 0,
		isOffSale = 0,
		collectibleItemId = 0,
		collectibleItemDetails = 0,
		assetsInBundle = 0,
		favoritesDetails = 0,
		timedOptions = 0,
		expirationTime = 0
	}
	local itemSubType

	if itemType == ItemTypeEnum.Bundle then
		itemSubType = v.bundleType
	else
		itemSubType = v.assetType
	end

	v2.itemSubType = itemSubType
	local v3

	if creator then
		v3 = creator.id
	end

	local creator2 = {
		creatorId = v3 or "",
		creatorName = 0,
		creatorHasVerifiedBadge = 0
	}
	local v4

	if creator then
		v4 = creator.name
	end

	creator2.creatorName = v4 or v.creatorName or ""
	local v5

	if creator then
		v5 = creator.hasVerifiedBadge
	end

	creator2.creatorHasVerifiedBadge = v5 or false
	v2.creator = creator2

	v2.creatingUniverseId = v.creatingUniverseId
	v2.saleLocationType = v.saleLocationType
	v2.itemRestrictions = v.itemRestrictions or {}
	v2.priceInRobux = v.priceInRobux
	v2.discountInformation = v.discountInformation
	v2.catalogPriceStatus = v.priceStatus
	v2.isOwned = v.isOwned
	v2.isOffSale = v.isOffSale
	v2.collectibleItemId = v.collectibleItemId
	v2.collectibleItemDetails = buildCollectibleItemDetails(p, v)
	local assetsInBundle

	if itemType == ItemTypeEnum.Bundle then
		assetsInBundle = buildAssetsInBundle(v.items)
	end

	v2.assetsInBundle = assetsInBundle
	v2.favoritesDetails = { numFavorites = v.favoriteCount }

	v2.timedOptions = v.timedOptions
	v2.expirationTime = v.expirationTime
	return v2
end

return buildItemDataFromAXRodux
