local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local OrganicEventImpressionsSchema = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).ImpressionsReporter.OrganicEventImpressionsSchema
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums

local function analyticsImpl(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14) -- line: 22
	-- upvalues: ArgCheck (copy), HttpService (copy), OrganicEventImpressionsSchema (copy), Constants (copy), ImpressionEnums (copy)
	ArgCheck.isType(p2, "string", "openItemDetailPage event expects eventContext")
	ArgCheck.isType(p3, "number", "openItemDetailPage event expects pageNumber")
	ArgCheck.isType(p4, "string", "openItemDetailPage event expects categoryName")
	ArgCheck.isType(p5, "string", "openItemDetailPage event expects subCategoryName")
	ArgCheck.isTypeOrNil(p6, "string", "openItemDetailPage event expects sortType")
	ArgCheck.isTypeOrNil(p7, "table", "openItemDetailPage event expects filters")
	ArgCheck.isType(p8, "number", "openItemDetailPage event expects rank")
	ArgCheck.isType(p9, "string", "openItemDetailPage event expects itemId")
	ArgCheck.isType(p10, "string", "openItemDetailPage event expects itemType")
	ArgCheck.isTypeOrNil(p11, "string", "openItemDetailPage event expects itemSubType")
	ArgCheck.isTypeOrNil(p12, "boolean", "openItemDetailPage event expects fromProfile")
	ArgCheck.isTypeOrNil(p13, "string", "openItemDetailPage event expects requestId")

	local v23 = p7 and HttpService:JSONEncode(p7)
	local enumMap = OrganicEventImpressionsSchema.defaultItem.enumMap
	local v25 = if not enumMap or not enumMap.contentType then nil else enumMap.contentType[p10]

	p1:sendTelemetryEvent(p2, "marketplaceOrganicFELog", {
		feature = p12 and Constants.ProfileAnalyticsTag or Constants.AnalyticsTag,
		page = p3,
		actionType = ImpressionEnums.ActionType.ITEM_CLICK,
		requestId = p13,
		nav = p4,
		subNav = p5,
		sort = p14.sortEnumValue,
		absPositions = p8,
		itemId = p9,
		contentType = v25,
		assetType = if v25 ~= ImpressionEnums.MarketplaceItemType.ASSET then nil else p11,
		bundleType = if v25 ~= ImpressionEnums.MarketplaceItemType.BUNDLE then nil else p11,
		keyword = p7.keyword,
		category = p4,
		subcategory = p5,
		filterSalesType = p14.filterSalesTypeEnumValue,
		filterCreators = p14.filterCreatorsTypeEnumValue,
		filterPrice = p14.filterPriceEnumValue,
		filterUnavailableItems = p14.filterUnavailableItemsEnumValue,
		filterCreatorsName = p14.filterCreatorsName,
		filterPriceMin = p14.filterPriceMin,
		filterPriceMax = p14.filterPriceMax
	})
	p1:sendTelemetryEvent(p2, "itemDetailReferral", {
		feature = p12 and Constants.ProfileAnalyticsTag or Constants.AnalyticsTag,
		page = p3,
		nav = p4,
		subNav = p5,
		sort = p6,
		filters = v23,
		rank = p8,
		itemID = p9,
		itemType = p10,
		itemSubType = p11
	})
end

return analyticsImpl
