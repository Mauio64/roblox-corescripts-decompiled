local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dPs")
require("@luauforge/bundled/dPE")
require("@luauforge/bundled/dPF")
require("@luauforge/bundled/dPG")
require("@luauforge/bundled/dPH")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

return Rodux.makeActionCreator("NavigatedToDeepLinkCatalogFilter", function(data)
	return {
		creatorFilter = data.creatorFilter,
		priceRange = data.priceRange,
		salesTypeFilter = data.salesTypeFilter,
		unavailableItemFilter = data.unavailableItemFilter,
		sortType = data.sortType,
		sortAggregation = data.sortAggregation,
		category = data.category,
		subcategory = data.subcategory,
		topics = data.topics,
		wearTimeFilter = data.wearTimeFilter,
		taxonomy = data.taxonomy
	}
end)
