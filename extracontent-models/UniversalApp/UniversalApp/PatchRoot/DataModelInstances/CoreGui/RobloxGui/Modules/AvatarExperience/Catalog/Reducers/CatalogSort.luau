local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local SetCatalogSort = require(Modules.AvatarExperience.Catalog.Actions.SetCatalogSort)
local ResetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.ResetSortAndFilters)
local SetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.SetSortAndFilters)

require(Modules.AvatarExperience.Common.Enum.SortType)

local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)

return Rodux.createReducer(CatalogConstants.DefaultFilters.CatalogSort, {
	[SetCatalogSort.name] = function(_, p2) -- line: 21
		return p2.sort
	end,
	[ResetSortAndFilters.name] = function(_, _) -- line: 24
		-- upvalues: CatalogConstants (copy)
		return CatalogConstants.DefaultFilters.CatalogSort
	end,
	[SetSortAndFilters.name] = function(p5, p6) -- line: 27
		return p6.CatalogSort or p5
	end,
	[NavigatedToDeepLinkCatalogFilter.name] = function(p7, p8) -- line: 30
		return p8.sortType or p7
	end
})
