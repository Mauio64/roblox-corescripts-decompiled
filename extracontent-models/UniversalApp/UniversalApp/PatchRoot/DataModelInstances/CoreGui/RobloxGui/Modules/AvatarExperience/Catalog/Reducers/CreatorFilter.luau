local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local SetCreatorFilter = require(Modules.AvatarExperience.Catalog.Actions.SetCreatorFilter)
local ResetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.ResetSortAndFilters)
local SetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.SetSortAndFilters)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)

return (Rodux.createReducer(CatalogConstants.DefaultFilters.CreatorFilter, {
	[SetCreatorFilter.name] = function(_: string, p1) -- line: 26
		return p1.creatorFilter
	end,
	[ResetSortAndFilters.name] = function(_: string, _) -- line: 29
		-- upvalues: CatalogConstants (copy)
		return CatalogConstants.DefaultFilters.CreatorFilter
	end,
	[SetSortAndFilters.name] = function(s3: string, p3) -- line: 32
		return p3.CreatorFilter or s3
	end,
	[NavigatedToDeepLinkCatalogFilter.name] = function(s4: string, p4) -- line: 35
		return p4.creatorFilter or s4
	end
}))
