local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMarketplaceAssetStore = require(script.Parent.createMarketplaceAssetStore)

return Signals.createComputed(createMarketplaceAssetStore)
