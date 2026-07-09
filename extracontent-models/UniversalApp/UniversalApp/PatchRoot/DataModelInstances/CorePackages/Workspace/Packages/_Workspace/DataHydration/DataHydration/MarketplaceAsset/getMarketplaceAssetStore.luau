local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createMarketplaceAssetStore = require(script.Parent.createMarketplaceAssetStore)

return Signals.createComputed(createMarketplaceAssetStore)
