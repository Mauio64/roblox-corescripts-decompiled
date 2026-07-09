local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local ClearSelectedTopics = require(Modules.AvatarExperience.Catalog.Actions.ClearSelectedTopics)
local SetSelectedTopics = require(Modules.AvatarExperience.Catalog.Actions.SetSelectedTopics)
local SetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.SetSortAndFilters)
local ResetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.ResetSortAndFilters)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)

return Rodux.createReducer(CatalogConstants.DefaultFilters.SelectedTopics, {
	[SetSelectedTopics.name] = function(_: {[any]: any}, p1) -- line: 23
		return p1.selectedTopics
	end,
	[ClearSelectedTopics.name] = function(_: {[any]: any}, _) -- line: 27
		-- upvalues: CatalogConstants (copy)
		return CatalogConstants.DefaultFilters.SelectedTopics
	end,
	[SetSortAndFilters.name] = function(t3: {[any]: any}, p3) -- line: 31
		return p3.SelectedTopics or t3
	end,
	[ResetSortAndFilters.name] = function(_: {[any]: any}, _) -- line: 35
		-- upvalues: CatalogConstants (copy)
		return CatalogConstants.DefaultFilters.SelectedTopics
	end,
	[NavigatedToDeepLinkCatalogFilter.name] = function(t5: {[any]: any}, p5) -- line: 38
		return p5.topics or t5
	end
})
