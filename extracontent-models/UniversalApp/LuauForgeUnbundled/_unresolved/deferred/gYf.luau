local module = require("@luauforge/bundled/fuL")
local module2 = require("@luauforge/bundled/dME")
local module3 = require("@luauforge/bundled/dMq")
local module4 = require("@luauforge/bundled/dMp")
local module5 = require("@luauforge/bundled/dMo")
local addAnalyticsMetadata = require("@luauforge/bundled/dHL").Actions.AddAnalyticsMetadata
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local defineFastFlag = game:DefineFastFlag("AXUpdateAnalyticsFiltersEnums", false)
local defineFastFlag2 = game:DefineFastFlag("AXDeprecateAnalyticsFiltersEnums", false)

local fFlagAXFixUnifiedPurchaseFieldLanding = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixUnifiedPurchaseFieldLanding

local fFlagAXCatalogSpecialFeaturesFilter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogSpecialFeaturesFilter

local v5 = {
	Relevance = unifiedEventLogEnums.Sort.RELEVANCE,
	PriceLowToHigh = unifiedEventLogEnums.Sort.PRICE_LOW_TO_HIGH,
	PriceHighToLow = unifiedEventLogEnums.Sort.PRICE_HIGH_TO_LOW,
	RecentlyCreated = unifiedEventLogEnums.Sort.RECENTLY_CREATED,
	BestsellingAllTime = unifiedEventLogEnums.Sort.BEST_SELLING_ALL_TIME,
	BestsellingPastWeek = unifiedEventLogEnums.Sort.BEST_SELLING_PAST_WEEK,
	BestsellingPastDay = unifiedEventLogEnums.Sort.BEST_SELLING_PAST_DAY,
	MostFavoritedAllTime = unifiedEventLogEnums.Sort.MOST_FAVORITED_ALL_TIME,
	MostFavoritedPastWeek = unifiedEventLogEnums.Sort.MOST_FAVORITED_PAST_WEEK,
	MostFavoritedPastDay = unifiedEventLogEnums.Sort.MOST_FAVORITED_PAST_DAY
}

local function getEnumValue(p2, value)
	return v5[p2 .. (value or "")]
end

return function(p2)
	return function(object)
		local state = object:getState()

		local minPrice = module.selectMinPrice(state)

		if minPrice == module2.MinPriceFilter then
			minPrice = nil
		end

		local maxPrice = module.selectMaxPrice(state)

		if maxPrice == module2.MaxPriceFilter then
			maxPrice = nil
		end

		local catalogSort = module.selectCatalogSort(state)
		local v6

		if catalogSort == module3.MostFavorited or catalogSort == module3.Bestselling then
			v6 = module.selectCatalogSortAggregation(state)
		end

		local salesTypeFilter = module.selectSalesTypeFilter(state)

		if salesTypeFilter == module4.All then
			salesTypeFilter = nil
		end

		local creatorFilter = module.selectCreatorFilter(state)

		if creatorFilter == "" then
			creatorFilter = nil
		end

		local v7 = module.selectUnavailableItemFilter(state) == module5.Show or nil

		local joined = nil

		if fFlagAXCatalogSpecialFeaturesFilter then
			local specialFeaturesFilter = module.selectSpecialFeaturesFilter(state)

			if specialFeaturesFilter and #specialFeaturesFilter > 0 then
				joined = table.concat(specialFeaturesFilter, ",")
			end
		end

		if catalogSort then
			local v10 = if not defineFastFlag2 then v5[catalogSort .. (v6 or "")] else nil
			local v11 = if defineFastFlag then v5[catalogSort .. (v6 or "")] else nil

			object:dispatch(addAnalyticsMetadata({ sortEnumValue = v10, sort = v11 }))
		end

		local v10

		if not defineFastFlag2 then
			if salesTypeFilter == module4.Collectibles then
				v10 = unifiedEventLogEnums.FiltersSalesType.SALES_TYPE_LIMITED
			else
				v10 = unifiedEventLogEnums.FiltersSalesType.SALES_TYPE_ALL
			end
		end

		local v11

		if not defineFastFlag2 then
			if creatorFilter then
				v11 = unifiedEventLogEnums.FiltersCreators.CREATORS_BY_USERNAME
			else
				v11 = unifiedEventLogEnums.FiltersCreators.CREATORS_ALL
			end
		end

		local v12

		if not defineFastFlag2 then
			if minPrice or maxPrice then
				v12 = unifiedEventLogEnums.FiltersPrice.PRICE_RANGE
			else
				v12 = unifiedEventLogEnums.FiltersPrice.PRICE_ANY
			end
		end

		local v13

		if not defineFastFlag2 then
			if v7 then
				v13 = unifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_SHOW
			else
				v13 = unifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_HIDE
			end
		end

		local v14

		if defineFastFlag then
			if salesTypeFilter == module4.Collectibles then
				v14 = unifiedEventLogEnums.FiltersSalesType.SALES_TYPE_LIMITED
			else
				v14 = unifiedEventLogEnums.FiltersSalesType.SALES_TYPE_ALL
			end
		end

		local v15

		if defineFastFlag then
			if creatorFilter then
				v15 = unifiedEventLogEnums.FiltersCreators.CREATORS_BY_USERNAME
			else
				v15 = unifiedEventLogEnums.FiltersCreators.CREATORS_ALL
			end
		end

		local v16

		if defineFastFlag then
			if minPrice or maxPrice then
				v16 = unifiedEventLogEnums.FiltersPrice.PRICE_RANGE
			else
				v16 = unifiedEventLogEnums.FiltersPrice.PRICE_ANY
			end
		end

		local v17

		if defineFastFlag then
			if v7 then
				v17 = unifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_SHOW
			else
				v17 = unifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_HIDE
			end
		end

		object:dispatch(addAnalyticsMetadata({
			filterSalesTypeEnumValue = v10,
			filterCreatorsTypeEnumValue = v11,
			filterPriceEnumValue = v12,
			filterUnavailableItemsEnumValue = v13,
			filterSalesType = v14,
			filterCreatorsType = v15,
			filterPrice = v16,
			filterUnavailableItems = v17,
			filterCreatorsName = creatorFilter or "",
			filterPriceMin = not minPrice and "" or tostring(minPrice),
			filterPriceMax = not maxPrice and "" or tostring(maxPrice)
		}))

		if fFlagAXFixUnifiedPurchaseFieldLanding then
			local v20 = if catalogSort then v5[catalogSort .. (v6 or "")] else nil

			local v21 = if salesTypeFilter == module4.Collectibles then unifiedEventLogEnums.FiltersSalesType.SALES_TYPE_LIMITED else unifiedEventLogEnums.FiltersSalesType.SALES_TYPE_ALL

			local v22 = if creatorFilter then unifiedEventLogEnums.FiltersCreators.CREATORS_BY_USERNAME else unifiedEventLogEnums.FiltersCreators.CREATORS_ALL

			local v23 = if minPrice or maxPrice then unifiedEventLogEnums.FiltersPrice.PRICE_RANGE else unifiedEventLogEnums.FiltersPrice.PRICE_ANY

			local v24 = if v7 then unifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_SHOW else unifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_HIDE
			object:dispatch(addAnalyticsMetadata({
				sort = v20,
				filterSalesType = v21,
				filterCreators = v22,
				filterPrice = v23,
				filterUnavailableItems = v24
			}))
		end

		p2.applySortAndFilters({
			minPrice = minPrice,
			maxPrice = maxPrice,
			sortType = catalogSort,
			sortAggregation = v6,
			salesTypeFilter = salesTypeFilter,
			creatorFilter = creatorFilter,
			includeOffSale = v7,
			specialFeaturesFilter = joined
		})
	end
end
