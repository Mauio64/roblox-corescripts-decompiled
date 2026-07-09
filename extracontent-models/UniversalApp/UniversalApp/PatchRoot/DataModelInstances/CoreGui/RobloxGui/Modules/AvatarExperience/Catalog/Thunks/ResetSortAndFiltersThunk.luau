local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ResetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.ResetSortAndFilters)
local AddAnalyticsMetadata = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.AddAnalyticsMetadata
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local t1 = {
	filterPriceMin = "",
	filterPriceMax = "",
	filterCreatorsName = "",
	sort = UnifiedEventLogEnums.Sort.RELEVANCE,
	filterSalesType = UnifiedEventLogEnums.FiltersSalesType.SALES_TYPE_ALL,
	filterCreatorsType = UnifiedEventLogEnums.FiltersCreators.CREATORS_ALL,
	filterPrice = UnifiedEventLogEnums.FiltersPrice.PRICE_ANY,
	filterUnavailableItems = UnifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_HIDE
}

return function() -- line: 21
	-- upvalues: ResetSortAndFilters (copy), AddAnalyticsMetadata (copy), t1 (copy)
	return function(p1) -- line: 22
		-- upvalues: ResetSortAndFilters (copy), AddAnalyticsMetadata (copy), t1 (copy)
		p1:dispatch(ResetSortAndFilters())
		p1:dispatch(AddAnalyticsMetadata(t1))
	end
end
