local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local SetPriceRange = require(Modules.AvatarExperience.Catalog.Actions.SetPriceRange)
local ResetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.ResetSortAndFilters)
local SetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.SetSortAndFilters)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)

require(Modules.AvatarExperience.Common.Types)

local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)

return Rodux.createReducer(CatalogConstants.DefaultFilters.PriceRange, {
	[SetPriceRange.name] = function(_, p2) -- line: 21
		return p2.priceRange
	end,
	[ResetSortAndFilters.name] = function(_, _) -- line: 24
		-- upvalues: CatalogConstants (copy)
		return CatalogConstants.DefaultFilters.PriceRange
	end,
	[SetSortAndFilters.name] = function(p5, p6) -- line: 27
		return p6.PriceRange or p5
	end,
	[NavigatedToDeepLinkCatalogFilter.name] = function(p7, p8) -- line: 30
		return p8.priceRange or p7
	end
})
