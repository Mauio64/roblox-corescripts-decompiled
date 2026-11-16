local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local normalize = AvatarExperienceCommon.Utils.normalize
local normalizeBoolean = normalize.normalizeBoolean
local normalizeString = normalize.normalizeString
local normalizeNumber = normalize.normalizeNumber
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local getRawItemLicensingInfo = AvatarExperienceCommon.Utils.getRawItemLicensingInfo

local convertToPascalCase = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/convertToPascalCase")
local fFlagAXMarketplaceLicensing = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXMarketplaceLicensing

local ASSET_TYPE_ID_STRING_TO_NAME = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Constants.ASSET_TYPE_ID_STRING_TO_NAME
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/CatalogV2SearchItemDetails")

local v5 = { "BodyParts", "Animations", "Shoes", "DynamicHead" }

local function normalizeBundledItem(data)
	return {
		Id = normalizeNumber(data.id),
		Name = normalizeString(data.name),
		Type = normalizeString(data.type)
	}
end

local function normalizeBundledItems(bundledItems)
	if typeof(bundledItems) ~= "table" then
		return nil
	end

	local result = {}

	for k, item in bundledItems do
		table.insert(result, {
			Id = normalizeNumber(item.id),
			Name = normalizeString(item.name),
			Type = normalizeString(item.type)
		})
	end

	return result
end

local function normalizeTimedOptions(data)
	local timedOptions

	if not data.timedOptions then
		return timedOptions
	end

	timedOptions = {}

	for k, timedOption in data.timedOptions do
		local v6 = {
			days = normalizeNumber(timedOption.days),
			price = normalizeNumber(timedOption.price),
			selected = 0,
			discountInformation = 0
		}
		local v7 = if timedOption.selected then normalizeBoolean(timedOption.selected) else nil
		v6.selected = v7
		v6.discountInformation = timedOption.discountInformation
		table.insert(timedOptions, v6)
	end

	return timedOptions
end

local function normalizeItem(item)
	if type(item) ~= "table" then
		return nil, "Item must be a table"
	end

	local v6 = if item.assetType then ASSET_TYPE_ID_STRING_TO_NAME[tostring(item.assetType)] else nil
	local v7

	if type(item.bundleType) == "number" then
		v7 = v5[item.bundleType] or tostring(item.bundleType)
	else
		v7 = item.bundleType
	end

	local rawItemLicensingInfo = getRawItemLicensingInfo(item)

	local v8 = {
		assetType = normalizeString(v6),
		bundleType = normalizeString(v7),
		bundledItems = normalizeBundledItems(item.bundledItems),
		collectibleItemId = normalizeString(item.collectibleItemId),
		creatorHasVerifiedBadge = normalizeBoolean(item.creatorHasVerifiedBadge),
		creatorName = normalizeString(item.creatorName),
		creatorTargetId = normalizeNumber(item.creatorTargetId),
		creatorType = normalizeString(item.creatorType),
		description = normalizeString(item.description),
		favoriteCount = normalizeNumber(item.favoriteCount),
		hasResellers = normalizeBoolean(item.hasResellers),
		id = normalizeNumber(item.id),
		isRecolorable = normalizeBoolean(item.isRecolorable),
		itemRestrictions = item.itemRestrictions or {},
		itemStatus = item.itemStatus or {},
		itemType = normalizeString(item.itemType),
		lowestPrice = normalizeNumber(item.lowestPrice),
		lowestResalePrice = normalizeNumber(item.lowestResalePrice),
		name = normalizeString(item.name),
		price = normalizeNumber(item.price),
		productId = normalizeNumber(item.productId),
		priceStatus = normalizeString(item.priceStatus),
		saleLocationType = normalizeString(item.saleLocationType),
		totalQuantity = normalizeNumber(item.totalQuantity),
		unitsAvailableForConsumption = normalizeNumber(item.unitsAvailableForConsumption),
		offSaleDeadline = normalizeString(item.offSaleDeadline),
		quantityLimitPerUser = normalizeNumber(item.quantityLimitPerUser),
		isOffSale = normalizeBoolean(item.isOffSale),
		timedOptions = normalizeTimedOptions(item),
		itemLicensingInfo = 0
	}

	if not fFlagAXMarketplaceLicensing then
		rawItemLicensingInfo = nil
	end

	v8.itemLicensingInfo = rawItemLicensingInfo

	return convertToPascalCase(v8), nil
end

local function normalizeItemsData(items)
	if typeof(items) ~= "table" then
		return nil, nil
	end

	local v6 = {}
	local result = {}

	for k, item in items do
		local item2, v7 = normalizeItem(item)
		table.insert(v6, v7)
		result[k] = item2
	end

	local v7 = if next(v6) then table.concat(v6, " ") else nil

	return result, v7
end

return (makeNormalizeTableFn({
	data = normalizeItemsData,
	nextPageCursor = normalizeString
}))
