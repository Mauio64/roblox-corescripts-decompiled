require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceRodux")
local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/tutils")
local itemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local function buildCollectibleItemDetails(p2, data)
	local collectibles = p2.Collectibles
	local collectibleItemId = data.collectibleItemId
	local v5

	if collectibles and collectibleItemId and collectibles.CollectiblesItemInfo then
		v5 = collectibles.CollectiblesItemInfo[collectibleItemId]
	end

	local v6

	if collectibles and collectibleItemId and collectibles.CollectiblesResellableInstances then
		v6 = collectibles.CollectiblesResellableInstances[collectibleItemId]
	end

	local v7 = not v6 and 0 or tutils.fieldCount(v6)
	local lowestAvailableResaleProductId = if v5 then v5.lowestAvailableResaleProductId else nil

	local v8 = if v5 then v5.quantityLimitPerUser else nil

	local v9 = if v5 then v5.collectibleProductId else nil

	local v10 = if v5 then v5.lowestAvailableResaleItemInstanceId else nil

	local v11 = if v5 then v5.unitsAvailableForConsumption else nil
	local collectibleItemDetails = {
		quantityLimitPerUser = v8,
		resellableCount = v7,
		collectibleProductId = v9,
		collectibleLowestAvailableResaleProductId = lowestAvailableResaleProductId,
		collectibleLowestAvailableResaleItemInstanceId = v10,
		unitsAvailableForConsumption = v11 or data.numberRobloxHasAvailable,
		hasResellers = 0,
		lowestResalePrice = 0,
		totalQuantity = 0,
		experiences = 0
	}

	local v12 = data.hasResellers

	if not v12 then
		v12 = (if v5 then v5.hasResellers else nil)
			or lowestAvailableResaleProductId ~= nil and lowestAvailableResaleProductId ~= ""
	end

	collectibleItemDetails.hasResellers = v12

	collectibleItemDetails.lowestResalePrice = data.lowestResalePrice
	collectibleItemDetails.totalQuantity = data.totalQuantity
	local experiences = data.experiences

	if not experiences then
		experiences = if v5 then v5.experiences else nil
	end

	collectibleItemDetails.experiences = experiences
	return collectibleItemDetails
end

local function buildAssetsInBundle(items)
	if not items then
		return nil
	end

	local result = {}

	for k, item in items do
		local v5 = { id = tostring(item.id), assetType = 0 }
		local v6 = if item.assetType ~= nil then tostring(item.assetType) else nil
		v5.assetType = v6
		table.insert(result, v5)
	end

	return result
end

local function buildItemDataFromAXRodux(p2, p3, p4)
	if not p2 then
		return nil
	end

	local v5 = nil

	if p4 == itemTypeEnum.Asset then
		if p2.AssetInfos then
			v5 = p2.AssetInfos[p3]
		end
	elseif p4 == itemTypeEnum.Bundle and p2.BundleInfos then
		v5 = p2.BundleInfos[p3]
	end

	if not v5 then
		return nil
	end

	local creator = v5.creator

	local v6 = {
		id = p3,
		name = v5.name,
		description = v5.description,
		itemType = p4,
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

	local v7 = if p4 == itemTypeEnum.Bundle then v5.bundleType else v5.assetType
	v6.itemSubType = v7

	local v9 = if creator then creator.id else nil
	local v10 = if creator then creator.name else nil
	local v8 = {
		creatorId = v9 or "",
		creatorName = v10 or v5.creatorName or "",
		creatorHasVerifiedBadge = 0
	}
	local v11 = if creator then creator.hasVerifiedBadge else nil
	v8.creatorHasVerifiedBadge = v11 or false
	v6.creator = v8

	v6.creatingUniverseId = v5.creatingUniverseId
	v6.saleLocationType = v5.saleLocationType
	v6.itemRestrictions = v5.itemRestrictions or {}
	v6.priceInRobux = v5.priceInRobux
	v6.discountInformation = v5.discountInformation
	v6.catalogPriceStatus = v5.priceStatus
	v6.isOwned = v5.isOwned
	v6.isOffSale = v5.isOffSale
	v6.collectibleItemId = v5.collectibleItemId
	v6.collectibleItemDetails = buildCollectibleItemDetails(p2, v5)
	local v12 = if p4 == itemTypeEnum.Bundle then buildAssetsInBundle(v5.items) else nil
	v6.assetsInBundle = v12
	v6.favoritesDetails = { numFavorites = v5.favoriteCount }

	v6.timedOptions = v5.timedOptions
	v6.expirationTime = v5.expirationTime
	return v6
end

return buildItemDataFromAXRodux
