local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local CatalogSort = require(Modules.AvatarExperience.Catalog.Reducers.CatalogSort)
local CatalogSortAggregation = require(Modules.AvatarExperience.Catalog.Reducers.CatalogSortAggregation)
local PriceRange = require(Modules.AvatarExperience.Catalog.Reducers.PriceRange)
local SalesTypeFilter = require(Modules.AvatarExperience.Catalog.Reducers.SalesTypeFilter)
local CreatorFilter = require(Modules.AvatarExperience.Catalog.Reducers.CreatorFilter)
local UnavailableItemFilter = require(Modules.AvatarExperience.Catalog.Reducers.UnavailableItemFilter)
local SelectedTopics = require(Modules.AvatarExperience.Catalog.Reducers.SelectedTopics)
local WearTimeFilter = require(Modules.AvatarExperience.Catalog.Reducers.WearTimeFilter)

return Rodux.combineReducers({
	CatalogSort = CatalogSort,
	CatalogSortAggregation = CatalogSortAggregation,
	PriceRange = PriceRange,
	SalesTypeFilter = SalesTypeFilter,
	CreatorFilter = CreatorFilter,
	UnavailableItemFilter = UnavailableItemFilter,
	SelectedTopics = SelectedTopics,
	WearTimeFilter = WearTimeFilter
})
