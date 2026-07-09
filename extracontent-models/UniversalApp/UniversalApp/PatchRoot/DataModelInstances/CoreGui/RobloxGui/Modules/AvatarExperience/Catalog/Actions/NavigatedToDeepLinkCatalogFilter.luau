local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Common.Enum.UnavailableItemFilter)
require(Modules.AvatarExperience.Common.Enum.SalesTypeFilter)
require(Modules.AvatarExperience.Common.Enum.SortType)
require(Modules.AvatarExperience.Common.Enum.SortAggregation)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 27
	return {
		creatorFilter = t1.creatorFilter,
		priceRange = t1.priceRange,
		salesTypeFilter = t1.salesTypeFilter,
		unavailableItemFilter = t1.unavailableItemFilter,
		sortType = t1.sortType,
		sortAggregation = t1.sortAggregation,
		category = t1.category,
		subcategory = t1.subcategory,
		topics = t1.topics,
		wearTimeFilter = t1.wearTimeFilter,
		taxonomy = t1.taxonomy
	}
end)
