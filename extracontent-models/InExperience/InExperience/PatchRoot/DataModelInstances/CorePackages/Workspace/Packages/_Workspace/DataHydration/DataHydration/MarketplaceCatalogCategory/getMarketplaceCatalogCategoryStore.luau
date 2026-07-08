local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createMarketplaceCatalogCategoryStore = require(script.Parent.createMarketplaceCatalogCategoryStore)

return Signals.createComputed(createMarketplaceCatalogCategoryStore)
