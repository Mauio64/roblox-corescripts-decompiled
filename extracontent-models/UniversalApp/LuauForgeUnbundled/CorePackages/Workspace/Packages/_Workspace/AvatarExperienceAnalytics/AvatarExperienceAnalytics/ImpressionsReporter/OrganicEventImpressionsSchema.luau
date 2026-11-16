local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Constants")
local ImpressionEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Enums/ImpressionEnums")
local ImpressionsUtil = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/ImpressionsReporter/ImpressionsUtil")

local fFlagAXFixUnifiedPurchaseFieldLanding = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXFixUnifiedPurchaseFieldLanding

local v5 = {
	defaultItem = ImpressionsUtil.buildSchema(Constants.IMPRESSIONS_EVENTS.AvatarItems, {
		enumMap = {
			contentType = {
				Asset = ImpressionEnums.MarketplaceItemType.ASSET,
				Bundle = ImpressionEnums.MarketplaceItemType.BUNDLE,
				Look = ImpressionEnums.MarketplaceItemType.LOOK
			}
		},
		surfaceSpecificAnalyticsMetadata = {
			[ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE] = {
				{ prop = "sortEnumValue", out = "sort" },
				{ prop = "filterSalesTypeEnumValue", out = "filterSalesType" },
				{ prop = "filterCreatorsTypeEnumValue", out = "filterCreators" },
				{ prop = "filterPriceEnumValue", out = "filterPrice" },
				{
					prop = "filterUnavailableItemsEnumValue",
					out = "filterUnavailableItems"
				},
				{ prop = "filterCreatorsName", out = "filterCreatorsName" },
				{ prop = "filterPriceMin", out = "filterPriceMin" },
				{ prop = "filterPriceMax", out = "filterPriceMax" }
			},
			[ImpressionEnums.MarketplaceSurfaceType.SEARCH] = {},
			[ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY] = {}
		},
		mapping = {
			{ prop = "index", out = "absPositions" },
			{ prop = "itemId", out = "itemId" },
			{ prop = "itemType", out = "contentType" },
			{ prop = "impressionsGroup", out = "group" },
			{ prop = "impressionsSearch", out = "keyword" },
			{ prop = "impressionsCategory", out = "category" },
			{ prop = "impressionsSubcategory", out = "subcategory" },
			{ prop = "surface", out = "surface" },
			{ prop = "sort", out = "sort" }
		},
		groupBy = { "itemId" }
	})
}

local surfaceSpecificAnalyticsMetadata = fFlagAXFixUnifiedPurchaseFieldLanding
	and v5.defaultItem.surfaceSpecificAnalyticsMetadata

if surfaceSpecificAnalyticsMetadata then
	surfaceSpecificAnalyticsMetadata[ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE] = {
		{ prop = "sort", out = "sort" },
		{ prop = "filterSalesType", out = "filterSalesType" },
		{ prop = "filterCreators", out = "filterCreators" },
		{ prop = "filterPrice", out = "filterPrice" },
		{ prop = "filterUnavailableItems", out = "filterUnavailableItems" },
		{ prop = "filterCreatorsName", out = "filterCreatorsName" },
		{ prop = "filterPriceMin", out = "filterPriceMin" },
		{ prop = "filterPriceMax", out = "filterPriceMax" }
	}
end

setmetatable(v5, {
	__newindex = function(p2, p3)
		error("Attempt to insert into impressions schemas: " .. p3)
	end,
	__index = function(p2, p3)
		if not p3 then
			warn("Nil ImpressionsSchema lookup")
			return
		end

		local v7 = rawget(p2, p3)

		if not v7 then
			warn("No such impressions schema: " .. p3)
		end

		return v7
	end
})

return v5
