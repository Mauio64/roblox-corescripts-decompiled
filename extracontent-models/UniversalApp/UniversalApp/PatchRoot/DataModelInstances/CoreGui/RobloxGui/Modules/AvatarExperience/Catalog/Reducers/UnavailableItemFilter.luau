local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local SetUnavailableItemFilter = require(Modules.AvatarExperience.Catalog.Actions.SetUnavailableItemFilter)
local ResetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.ResetSortAndFilters)
local SetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.SetSortAndFilters)

require(Modules.AvatarExperience.Common.Enum.UnavailableItemFilter)

local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)

return Rodux.createReducer(CatalogConstants.DefaultFilters.UnavailableItemFilter, {
	[SetUnavailableItemFilter.name] = function(_, p2) -- line: 25
		return p2.unavailableItemFilter
	end,
	[ResetSortAndFilters.name] = function(_, _) -- line: 28
		-- upvalues: CatalogConstants (copy)
		return CatalogConstants.DefaultFilters.UnavailableItemFilter
	end,
	[SetSortAndFilters.name] = function(p5, p6) -- line: 31
		return p6.UnavailableItemFilter or p5
	end,
	[NavigatedToDeepLinkCatalogFilter.name] = function(p7, p8) -- line: 34
		return p8.unavailableItemFilter or p7
	end
})
