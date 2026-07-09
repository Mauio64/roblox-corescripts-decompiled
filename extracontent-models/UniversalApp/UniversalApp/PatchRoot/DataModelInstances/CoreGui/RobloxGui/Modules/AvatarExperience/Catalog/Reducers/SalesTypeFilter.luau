local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local SetSalesTypeFilter = require(Modules.AvatarExperience.Catalog.Actions.SetSalesTypeFilter)
local ResetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.ResetSortAndFilters)
local SetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.SetSortAndFilters)

require(Modules.AvatarExperience.Common.Enum.SalesTypeFilter)

local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)

return (Rodux.createReducer(CatalogConstants.DefaultFilters.SalesTypeFilter, {
	[SetSalesTypeFilter.name] = function(_, p2) -- line: 27
		return p2.salesType
	end,
	[ResetSortAndFilters.name] = function(_, _) -- line: 30
		-- upvalues: CatalogConstants (copy)
		return CatalogConstants.DefaultFilters.SalesTypeFilter
	end,
	[SetSortAndFilters.name] = function(p5, p6) -- line: 33
		return p6.SalesTypeFilter or p5
	end,
	[NavigatedToDeepLinkCatalogFilter.name] = function(p7, p8) -- line: 36
		return p8.salesTypeFilter or p7
	end
}))
