local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createMarketplaceCatalogSortStore = require(script.Parent.createMarketplaceCatalogSortStore)

return Signals.createComputed(createMarketplaceCatalogSortStore)
