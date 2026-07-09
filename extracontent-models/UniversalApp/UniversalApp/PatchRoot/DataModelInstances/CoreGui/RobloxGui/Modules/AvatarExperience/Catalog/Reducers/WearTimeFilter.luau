local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local SetWearTimeFilter = require(Modules.AvatarExperience.Catalog.Actions.SetWearTimeFilter)
local ResetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.ResetSortAndFilters)
local SetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.SetSortAndFilters)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)

return (Rodux.createReducer(CatalogConstants.DefaultFilters.WearTimeFilter, {
	[SetWearTimeFilter.name] = function(_, p2) -- line: 27
		return p2.wearTimeFilter
	end,
	[ResetSortAndFilters.name] = function(_, _) -- line: 30
		-- upvalues: CatalogConstants (copy)
		return CatalogConstants.DefaultFilters.WearTimeFilter
	end,
	[SetSortAndFilters.name] = function(p5, p6) -- line: 33
		return p6.WearTimeFilter or p5
	end,
	[NavigatedToDeepLinkCatalogFilter.name] = function(p7, p8) -- line: 36
		return p8.wearTimeFilter or p7
	end
}))
