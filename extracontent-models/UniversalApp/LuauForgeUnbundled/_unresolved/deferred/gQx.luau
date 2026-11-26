local module = require("@luauforge/bundled/dVR")
local addAnalyticsMetadata = require("@luauforge/bundled/dKU").Actions.AddAnalyticsMetadata
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local fFlagAXFixUnifiedPurchaseFieldLanding = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixUnifiedPurchaseFieldLanding

local v5 = {
	sort = unifiedEventLogEnums.Sort.RELEVANCE,
	filterSalesType = unifiedEventLogEnums.FiltersSalesType.SALES_TYPE_ALL,
	filterCreatorsType = unifiedEventLogEnums.FiltersCreators.CREATORS_ALL,
	filterPrice = unifiedEventLogEnums.FiltersPrice.PRICE_ANY,
	filterUnavailableItems = unifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_HIDE,
	filterPriceMin = "",
	filterPriceMax = "",
	filterCreatorsName = ""
}

local v6 = {
	sort = unifiedEventLogEnums.Sort.RELEVANCE,
	filterSalesType = unifiedEventLogEnums.FiltersSalesType.SALES_TYPE_ALL,
	filterCreators = unifiedEventLogEnums.FiltersCreators.CREATORS_ALL,
	filterCreatorsType = unifiedEventLogEnums.FiltersCreators.CREATORS_ALL,
	filterPrice = unifiedEventLogEnums.FiltersPrice.PRICE_ANY,
	filterUnavailableItems = unifiedEventLogEnums.FiltersUnavailableItems.UNAVAILABLE_ITEMS_HIDE,
	filterPriceMin = "",
	filterPriceMax = "",
	filterCreatorsName = ""
}

return function()
	return function(object)
		object:dispatch(module())

		if fFlagAXFixUnifiedPurchaseFieldLanding then
			object:dispatch(addAnalyticsMetadata(v6))
		else
			object:dispatch(addAnalyticsMetadata(v5))
		end
	end
end
