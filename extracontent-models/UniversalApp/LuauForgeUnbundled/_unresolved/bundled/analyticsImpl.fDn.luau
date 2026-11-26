local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dzP")
local module2 = require("@luauforge/bundled/dPN")

local organicEventImpressionsSchema = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").ImpressionsReporter.OrganicEventImpressionsSchema
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums

local fFlagAXFixUnifiedPurchaseFieldLanding = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixUnifiedPurchaseFieldLanding

local aliasSortAndFiltersToLegacyKeys = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Utils.aliasSortAndFiltersToLegacyKeys

local function analyticsImpl(object, p2, p3, category, subcategory, p4, p5, p6, p7, p8, p9, p10, p11, data)
	module.isType(p2, "string", "openItemDetailPage event expects eventContext")
	module.isType(p3, "number", "openItemDetailPage event expects pageNumber")
	module.isType(category, "string", "openItemDetailPage event expects categoryName")
	module.isType(subcategory, "string", "openItemDetailPage event expects subCategoryName")
	module.isTypeOrNil(p4, "string", "openItemDetailPage event expects sortType")
	module.isTypeOrNil(p5, "table", "openItemDetailPage event expects filters")
	module.isType(p6, "number", "openItemDetailPage event expects rank")
	module.isType(p7, "string", "openItemDetailPage event expects itemId")
	module.isType(p8, "string", "openItemDetailPage event expects itemType")
	module.isTypeOrNil(p9, "string", "openItemDetailPage event expects itemSubType")
	module.isTypeOrNil(p10, "boolean", "openItemDetailPage event expects fromProfile")
	module.isTypeOrNil(p11, "string", "openItemDetailPage event expects requestId")

	local v5 = p5 and HttpService:JSONEncode(p5)

	local enumMap = organicEventImpressionsSchema.defaultItem.enumMap
	local v6 = if enumMap and enumMap.contentType then enumMap.contentType[p8] else nil

	if fFlagAXFixUnifiedPurchaseFieldLanding then
		data = aliasSortAndFiltersToLegacyKeys(data)
	end

	local v7 = {
		feature = p10 and module2.ProfileAnalyticsTag or module2.AnalyticsTag,
		page = p3,
		actionType = impressionEnums.ActionType.ITEM_CLICK,
		requestId = p11,
		nav = category,
		subNav = subcategory,
		sort = data.sortEnumValue,
		absPositions = p6,
		itemId = p7,
		contentType = v6,
		assetType = 0,
		bundleType = 0,
		keyword = 0,
		category = 0,
		subcategory = 0,
		filterSalesType = 0,
		filterCreators = 0,
		filterPrice = 0,
		filterUnavailableItems = 0,
		filterCreatorsName = 0,
		filterPriceMin = 0,
		filterPriceMax = 0
	}

	local v8 = if v6 == impressionEnums.MarketplaceItemType.ASSET then p9 else nil
	v7.assetType = v8
	local v9 = if v6 == impressionEnums.MarketplaceItemType.BUNDLE then p9 else nil
	v7.bundleType = v9
	v7.keyword = p5.keyword
	v7.category = category
	v7.subcategory = subcategory
	v7.filterSalesType = data.filterSalesTypeEnumValue
	v7.filterCreators = data.filterCreatorsTypeEnumValue
	v7.filterPrice = data.filterPriceEnumValue
	v7.filterUnavailableItems = data.filterUnavailableItemsEnumValue
	v7.filterCreatorsName = data.filterCreatorsName
	v7.filterPriceMin = data.filterPriceMin
	v7.filterPriceMax = data.filterPriceMax

	object:sendTelemetryEvent(p2, "marketplaceOrganicFELog", v7)

	object:sendTelemetryEvent(p2, "itemDetailReferral", {
		feature = p10 and module2.ProfileAnalyticsTag or module2.AnalyticsTag,
		page = p3,
		nav = category,
		subNav = subcategory,
		sort = p4,
		filters = v5,
		rank = p6,
		itemID = p7,
		itemType = p8,
		itemSubType = p9
	})
end

return analyticsImpl
