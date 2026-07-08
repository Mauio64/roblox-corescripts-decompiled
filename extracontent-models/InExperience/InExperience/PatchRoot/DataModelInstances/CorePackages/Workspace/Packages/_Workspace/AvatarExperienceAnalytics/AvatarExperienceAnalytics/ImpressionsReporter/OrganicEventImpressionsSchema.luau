local Constants = require(script.Parent.Parent.Constants)
local ImpressionEnums = require(script.Parent.Parent.Enums.ImpressionEnums)
local ImpressionsUtil = require(script.Parent.ImpressionsUtil)
local t1 = {}
local t2 = {
	__newindex = function(_, p2) -- line: 13
		error("Attempt to insert into impressions schemas: " .. p2)
	end,
	__index = function(p3, p4) -- line: 17
		if not p4 then
			warn("Nil ImpressionsSchema lookup")

			return
		end

		local v10 = rawget(p3, p4)

		if not v10 then
			warn("No such impressions schema: " .. p4)
		end

		return v10
	end
}

t1.defaultItem = ImpressionsUtil.buildSchema(Constants.IMPRESSIONS_EVENTS.AvatarItems, {
	enumMap = {
		contentType = {
			Asset = ImpressionEnums.MarketplaceItemType.ASSET,
			Bundle = ImpressionEnums.MarketplaceItemType.BUNDLE,
			Look = ImpressionEnums.MarketplaceItemType.LOOK
		}
	},
	surfaceSpecificAnalyticsMetadata = {
		[ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE] = {
			{
				prop = "sortEnumValue",
				out = "sort"
			},
			{
				prop = "filterSalesTypeEnumValue",
				out = "filterSalesType"
			},
			{
				prop = "filterCreatorsTypeEnumValue",
				out = "filterCreators"
			},
			{
				prop = "filterPriceEnumValue",
				out = "filterPrice"
			},
			{
				prop = "filterUnavailableItemsEnumValue",
				out = "filterUnavailableItems"
			},
			{
				prop = "filterCreatorsName",
				out = "filterCreatorsName"
			},
			{
				prop = "filterPriceMin",
				out = "filterPriceMin"
			},
			{
				prop = "filterPriceMax",
				out = "filterPriceMax"
			}
		},
		[ImpressionEnums.MarketplaceSurfaceType.SEARCH] = {},
		[ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY] = {}
	},
	mapping = {
		{
			prop = "index",
			out = "absPositions"
		},
		{
			prop = "itemId",
			out = "itemId"
		},
		{
			prop = "itemType",
			out = "contentType"
		},
		{
			prop = "impressionsGroup",
			out = "group"
		},
		{
			prop = "impressionsSearch",
			out = "keyword"
		},
		{
			prop = "impressionsCategory",
			out = "category"
		},
		{
			prop = "impressionsSubcategory",
			out = "subcategory"
		},
		{
			prop = "surface",
			out = "surface"
		},
		{
			prop = "sort",
			out = "sort"
		}
	},
	groupBy = { "itemId" }
})
setmetatable(t1, t2)

return t1
