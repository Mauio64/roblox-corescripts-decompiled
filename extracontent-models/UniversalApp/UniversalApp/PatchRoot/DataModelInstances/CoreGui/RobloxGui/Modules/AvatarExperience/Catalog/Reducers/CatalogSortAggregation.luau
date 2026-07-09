local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local SetCatalogSort = require(Modules.AvatarExperience.Catalog.Actions.SetCatalogSort)
local ResetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.ResetSortAndFilters)
local SetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.SetSortAndFilters)

require(Modules.AvatarExperience.Common.Enum.SortAggregation)

local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)

return Rodux.createReducer(CatalogConstants.DefaultFilters.CatalogSortAggregation, {
	[SetCatalogSort.name] = function(_, p2) -- line: 24
		return p2.sortAggregation
	end,
	[ResetSortAndFilters.name] = function(_, _) -- line: 27
		-- upvalues: CatalogConstants (copy)
		return CatalogConstants.DefaultFilters.CatalogSortAggregation
	end,
	[SetSortAndFilters.name] = function(p5, p6) -- line: 30
		return p6.CatalogSortAggregation or p5
	end,
	[NavigatedToDeepLinkCatalogFilter.name] = function(p7, p8) -- line: 33
		return p8.sortAggregation or p7
	end
})
