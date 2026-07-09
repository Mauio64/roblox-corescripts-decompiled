local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local normalize = require(AvatarExperienceCatalogParent.AvatarExperienceCommon).Utils.normalize
local normalizeBoolean = normalize.normalizeBoolean
local normalizeString = normalize.normalizeString
local normalizeNumber = normalize.normalizeNumber
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local convertToPascalCase = require(AvatarExperienceCatalog.Utils.convertToPascalCase)
local ASSET_TYPE_ID_STRING_TO_NAME = require(AvatarExperienceCatalogParent.AvatarExperienceCommon).Constants.ASSET_TYPE_ID_STRING_TO_NAME

require(AvatarExperienceCatalog.Models.CatalogV2SearchItemDetails)

local t1 = {
	[1] = "BodyParts",
	[2] = "Animations",
	[3] = "Shoes",
	[4] = "DynamicHead"
}

local function normalizeBundledItem(p1) -- line: 31
	-- upvalues: normalizeNumber (copy), normalizeString (copy)
	return {
		Id = normalizeNumber(p1.id),
		Name = normalizeString(p1.name),
		Type = normalizeString(p1.type)
	}
end
local function normalizeBundledItems(t2: {[any]: any}?) -- line: 39
	-- upvalues: normalizeNumber (copy), normalizeString (copy)
	if typeof(t2) ~= "table" then
		return nil
	end

	local t3 = {}

	for _, v20 in t2 do
		table.insert(t3, {
			Id = normalizeNumber(v20.id),
			Name = normalizeString(v20.name),
			Type = normalizeString(v20.type)
		})
	end

	return t3
end
local function normalizeTimedOptions(p2) -- line: 52
	-- upvalues: normalizeNumber (copy), normalizeBoolean (copy)
	local t4 = nil

	if p2.timedOptions then
		t4 = {}

		for _, v24 in p2.timedOptions do
			table.insert(t4, {
				days = normalizeNumber(v24.days),
				price = normalizeNumber(v24.price),
				selected = if not v24.selected then nil else normalizeBoolean(v24.selected),
				discountInformation = v24.discountInformation
			})
		end
	end

	return t4
end
local function normalizeItem(p3) -- line: 68
	-- upvalues: ASSET_TYPE_ID_STRING_TO_NAME (copy), t1 (copy), normalizeString (copy), normalizeBundledItems (copy), normalizeBoolean (copy), normalizeNumber (copy), normalizeTimedOptions (copy), convertToPascalCase (copy)
	if type(p3) ~= "table" then
		return nil, "Item must be a table"
	end

	local v26 = if not p3.assetType then nil else ASSET_TYPE_ID_STRING_TO_NAME[tostring(p3.assetType)]
	local v27 = if type(p3.bundleType) ~= "number" then p3.bundleType else t1[p3.bundleType] or tostring(p3.bundleType)
	local t5 = {
		assetType = normalizeString(v26),
		bundleType = normalizeString(v27),
		bundledItems = normalizeBundledItems(p3.bundledItems),
		collectibleItemId = normalizeString(p3.collectibleItemId),
		creatorHasVerifiedBadge = normalizeBoolean(p3.creatorHasVerifiedBadge),
		creatorName = normalizeString(p3.creatorName),
		creatorTargetId = normalizeNumber(p3.creatorTargetId),
		creatorType = normalizeString(p3.creatorType),
		description = normalizeString(p3.description),
		favoriteCount = normalizeNumber(p3.favoriteCount),
		hasResellers = normalizeBoolean(p3.hasResellers),
		id = normalizeNumber(p3.id),
		isRecolorable = normalizeBoolean(p3.isRecolorable),
		itemRestrictions = p3.itemRestrictions or {},
		itemStatus = p3.itemStatus or {},
		itemType = normalizeString(p3.itemType),
		lowestPrice = normalizeNumber(p3.lowestPrice),
		lowestResalePrice = normalizeNumber(p3.lowestResalePrice),
		name = normalizeString(p3.name),
		price = normalizeNumber(p3.price),
		productId = normalizeNumber(p3.productId),
		priceStatus = normalizeString(p3.priceStatus),
		saleLocationType = normalizeString(p3.saleLocationType),
		totalQuantity = normalizeNumber(p3.totalQuantity),
		unitsAvailableForConsumption = normalizeNumber(p3.unitsAvailableForConsumption),
		offSaleDeadline = normalizeString(p3.offSaleDeadline),
		quantityLimitPerUser = normalizeNumber(p3.quantityLimitPerUser),
		isOffSale = normalizeBoolean(p3.isOffSale),
		timedOptions = normalizeTimedOptions(p3)
	}

	return convertToPascalCase(t5), nil
end
local function normalizeItemsData(t6: {[any]: any}) -- line: 120
	-- upvalues: normalizeItem (copy)
	if typeof(t6) ~= "table" then
		return nil, nil
	end

	local t7 = {}
	local t8 = {}

	for v32, v33 in t6 do
		local v34, v35 = normalizeItem(v33)

		table.insert(t8, v35)
		t7[v32] = v34
	end

	local v36 = nil

	if next(t8) then
		v36 = table.concat(t8, " ")
	end

	return t7, v36
end

return (makeNormalizeTableFn({
	data = normalizeItemsData,
	nextPageCursor = normalizeString
}))
