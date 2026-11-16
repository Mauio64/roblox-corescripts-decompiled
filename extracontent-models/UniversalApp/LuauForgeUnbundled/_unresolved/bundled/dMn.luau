local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dMc")
require("@luauforge/bundled/dMo")
require("@luauforge/bundled/dMp")
require("@luauforge/bundled/dMq")
require("@luauforge/bundled/dMr")
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
