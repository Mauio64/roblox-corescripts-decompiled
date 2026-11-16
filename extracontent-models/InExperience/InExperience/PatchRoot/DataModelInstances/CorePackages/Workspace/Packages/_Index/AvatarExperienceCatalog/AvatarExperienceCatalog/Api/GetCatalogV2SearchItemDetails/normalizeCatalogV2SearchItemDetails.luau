local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local normalize = AvatarExperienceCommon.Utils.normalize
local normalizeBoolean = normalize.normalizeBoolean
local normalizeString = normalize.normalizeString
local normalizeNumber = normalize.normalizeNumber
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local getRawItemLicensingInfo = AvatarExperienceCommon.Utils.getRawItemLicensingInfo

local convertToPascalCase = require(AvatarExperienceCatalog.Utils.convertToPascalCase)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMarketplaceLicensing = AvatarExperienceFlags.FFlagAXMarketplaceLicensing

local AvatarExperienceCommon2 = require(parent.AvatarExperienceCommon)
local ASSET_TYPE_ID_STRING_TO_NAME = AvatarExperienceCommon2.Constants.ASSET_TYPE_ID_STRING_TO_NAME
require(AvatarExperienceCatalog.Models.CatalogV2SearchItemDetails)

local v = { "BodyParts", "Animations", "Shoes", "DynamicHead" }

local function normalizeBundledItem(item) -- 1 equivalent call inferred from this helper
	return {
		Id = normalizeNumber(item.id),
		Name = normalizeString(item.name),
		Type = normalizeString(item.type)
	}
end

local function normalizeBundledItems(bundledItems)
	if typeof(bundledItems) ~= "table" then
		return nil
	end

	local result = {}

	for _, item in bundledItems do
		table.insert(result, normalizeBundledItem(item)) -- inferred equivalent call
	end

	return result
end

local function normalizeTimedOptions(data)
	local timedOptions

	if not data.timedOptions then
		return timedOptions
	end

	timedOptions = {}

	for _, timedOption in data.timedOptions do
		local v2 = {
			days = normalizeNumber(timedOption.days),
			price = normalizeNumber(timedOption.price),
			selected = 0,
			discountInformation = 0
		}
		local selected

		if timedOption.selected then
			selected = normalizeBoolean(timedOption.selected)
		end

		v2.selected = selected
		v2.discountInformation = timedOption.discountInformation
		table.insert(timedOptions, v2)
	end

	return timedOptions
end

local function normalizeItem(item)
	if type(item) ~= "table" then
		return nil, "Item must be a table"
	end

	local v2

	if item.assetType then
		v2 = ASSET_TYPE_ID_STRING_TO_NAME[tostring(item.assetType)]
	end

	local v3

	if type(item.bundleType) == "number" then
		v3 = v[item.bundleType] or tostring(item.bundleType)
	else
		v3 = item.bundleType
	end

	local rawItemLicensingInfo = getRawItemLicensingInfo(item)

	local v4 = {
		assetType = normalizeString(v2),
		bundleType = normalizeString(v3),
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

	if not FFlagAXMarketplaceLicensing then
		rawItemLicensingInfo = nil
	end

	v4.itemLicensingInfo = rawItemLicensingInfo

	return convertToPascalCase(v4), nil
end

local function normalizeItemsData(items)
	if typeof(items) ~= "table" then
		return nil, nil
	end

	local v2 = {}
	local result = {}

	for k, item in items do
		local item2, v3 = normalizeItem(item)
		table.insert(v2, v3)
		result[k] = item2
	end

	local v3

	if next(v2) then
		v3 = table.concat(v2, " ")
	end

	return result, v3
end

return (makeNormalizeTableFn({ data = normalizeItemsData, nextPageCursor = normalizeString }))
