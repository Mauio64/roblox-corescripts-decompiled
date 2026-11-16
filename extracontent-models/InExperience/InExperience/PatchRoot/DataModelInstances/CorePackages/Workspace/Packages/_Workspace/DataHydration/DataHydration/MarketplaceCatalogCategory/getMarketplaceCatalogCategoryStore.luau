local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMarketplaceCatalogCategoryStore = require(script.Parent.createMarketplaceCatalogCategoryStore)

return Signals.createComputed(createMarketplaceCatalogCategoryStore)
