local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMarketplaceCatalogSortStore = require(script.Parent.createMarketplaceCatalogSortStore)

return Signals.createComputed(createMarketplaceCatalogSortStore)
