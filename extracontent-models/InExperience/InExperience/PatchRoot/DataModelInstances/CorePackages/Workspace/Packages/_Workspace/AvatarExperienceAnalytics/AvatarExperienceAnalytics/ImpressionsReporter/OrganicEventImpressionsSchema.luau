local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local Constants = require(script.Parent.Parent.Constants)
local ImpressionEnums = require(script.Parent.Parent.Enums.ImpressionEnums)
local ImpressionsUtil = require(script.Parent.ImpressionsUtil)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXFixUnifiedPurchaseFieldLanding = AvatarExperienceFlags.FFlagAXFixUnifiedPurchaseFieldLanding

local OrganicEventImpressionsSchema = {
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
				{ prop = "filterUnavailableItemsEnumValue", out = "filterUnavailableItems" },
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

local surfaceSpecificAnalyticsMetadata = FFlagAXFixUnifiedPurchaseFieldLanding
	and OrganicEventImpressionsSchema.defaultItem.surfaceSpecificAnalyticsMetadata

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

setmetatable(OrganicEventImpressionsSchema, {
	__newindex = function(_, p)
		error("Attempt to insert into impressions schemas: " .. p)
	end,
	__index = function(p, p2)
		if not p2 then
			warn("Nil ImpressionsSchema lookup")
			return
		end

		local v = rawget(p, p2)

		if not v then
			warn("No such impressions schema: " .. p2)
		end

		return v
	end
})

return OrganicEventImpressionsSchema
