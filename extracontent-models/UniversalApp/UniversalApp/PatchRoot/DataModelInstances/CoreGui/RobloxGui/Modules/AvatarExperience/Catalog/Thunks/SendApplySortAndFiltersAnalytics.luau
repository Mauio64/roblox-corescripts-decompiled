local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local SortType = require(Modules.AvatarExperience.Common.Enum.SortType)
local SalesTypeFilter = require(Modules.AvatarExperience.Common.Enum.SalesTypeFilter)
local UnavailableItemFilter = require(Modules.AvatarExperience.Common.Enum.UnavailableItemFilter)
local AddAnalyticsMetadata = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.AddAnalyticsMetadata
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local v10 = game:DefineFastFlag("AXUpdateAnalyticsFiltersEnums", false)
local v11 = game:DefineFastFlag("AXDeprecateAnalyticsFiltersEnums", false)
local t1 = {
	Relevance = UnifiedEventLogEnums.Sort.RELEVANCE,
	PriceLowToHigh = UnifiedEventLogEnums.Sort.PRICE_LOW_TO_HIGH,
	PriceHighToLow = UnifiedEventLogEnums.Sort.PRICE_HIGH_TO_LOW,
	RecentlyCreated = UnifiedEventLogEnums.Sort.RECENTLY_CREATED,
	BestsellingAllTime = UnifiedEventLogEnums.Sort.BEST_SELLING_ALL_TIME,
	BestsellingPastWeek = UnifiedEventLogEnums.Sort.BEST_SELLING_PAST_WEEK,
	BestsellingPastDay = UnifiedEventLogEnums.Sort.BEST_SELLING_PAST_DAY,
	MostFavoritedAllTime = UnifiedEventLogEnums.Sort.MOST_FAVORITED_ALL_TIME,
	MostFavoritedPastWeek = UnifiedEventLogEnums.Sort.MOST_FAVORITED_PAST_WEEK,
	MostFavoritedPastDay = UnifiedEventLogEnums.Sort.MOST_FAVORITED_PAST_DAY
}

local function getEnumValue(p1, s1: string?) -- line: 36
	-- upvalues: t1 (copy)
	if not s1 then
		s1 = ""
	end

	return t1[p1 .. s1]
end

return function(p2) -- line: 44
	-- upvalues: FilterUtils (copy), CatalogConstants (copy), SortType (copy), SalesTypeFilter (copy), UnavailableItemFilter (copy), AddAnalyticsMetadata (copy), v11 (copy), t1 (copy), v10 (copy), UnifiedEventLogEnums (copy)
	return function(p3) -- line: 45
		-- upvalues: FilterUtils (copy), CatalogConstants (copy), SortType (copy), SalesTypeFilter (copy), UnavailableItemFilter (copy), AddAnalyticsMetadata (copy), v11 (copy), t1 (copy), v10 (copy), UnifiedEventLogEnums (copy), p2 (copy)
		local v18 = p3:getState()
		local v19 = FilterUtils.selectMinPrice(v18)

		if v19 == CatalogConstants.MinPriceFilter then
			v19 = nil
		end

		local v20 = FilterUtils.selectMaxPrice(v18)

		if v20 == CatalogConstants.MaxPriceFilter then
			v20 = nil
		end

		local v21 = FilterUtils.selectCatalogSort(v18)
		local v22 = if v21 ~= SortType.MostFavorited and v21 ~= SortType.Bestselling then nil else FilterUtils.selectCatalogSortAggregation(v18)
		local v23 = FilterUtils.selectSalesTypeFilter(v18)

		if v23 == SalesTypeFilter.All then
			v23 = nil
		end

		local v24 = FilterUtils.selectCreatorFilter(v18)

		if v24 == "" then
			v24 = nil
		end

		local v25 = FilterUtils.selectUnavailableItemFilter(v18) == UnavailableItemFilter.Show or nil

		if v21 then
			p3:dispatch(AddAnalyticsMetadata({
				sortEnumValue = if not v11 then t1[v21 .. (v22 or "")] else nil,
				sort = if not v10 then nil else t1[v21 .. (v22 or "")]
			}))
		end

		p3:dispatch(AddAnalyticsMetadata({
			filterSalesTypeEnumValue = if not v11 then if v23 ~= SalesTypeFilter.Collectibles then UnifiedEventLogEnums.FiltersSalesType.SALES_TYPE_ALL else UnifiedEventLogEnums.FiltersSalesType.SALES_TYPE_LIMITED else nil,
			filterCreatorsTypeEnumValue = if not v11 then if not v24 then UnifiedEventLogEnums.FiltersCreators.CREATORS_ALL else UnifiedEventLogEnums.FiltersCreators.CREATORS_BY_USERNAME else nil,
			filterPriceEnumValue = if not v11 then if not v19 and not v20 then UnifiedEventLogEnums.FiltersPrice.PRICE_ANY else UnifiedEventLogEnums.FiltersPrice.PRICE_RANGE else nil,
			filterUnavailableItemsEnumValue = if not v11 then if not v25 then UnifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_HIDE else UnifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_SHOW else nil,
			filterSalesType = if not v10 then nil else if v23 ~= SalesTypeFilter.Collectibles then UnifiedEventLogEnums.FiltersSalesType.SALES_TYPE_ALL else UnifiedEventLogEnums.FiltersSalesType.SALES_TYPE_LIMITED,
			filterCreatorsType = if not v10 then nil else if not v24 then UnifiedEventLogEnums.FiltersCreators.CREATORS_ALL else UnifiedEventLogEnums.FiltersCreators.CREATORS_BY_USERNAME,
			filterPrice = if not v10 then nil else if not v19 and not v20 then UnifiedEventLogEnums.FiltersPrice.PRICE_ANY else UnifiedEventLogEnums.FiltersPrice.PRICE_RANGE,
			filterUnavailableItems = if not v10 then nil else if not v25 then UnifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_HIDE else UnifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_SHOW,
			filterCreatorsName = v24 or "",
			filterPriceMin = not v19 and "" or tostring(v19),
			filterPriceMax = not v20 and "" or tostring(v20)
		}))
		p2.applySortAndFilters({
			minPrice = v19,
			maxPrice = v20,
			sortType = v21,
			sortAggregation = v22,
			salesTypeFilter = v23,
			creatorFilter = v24,
			includeOffSale = v25
		})
	end
end
