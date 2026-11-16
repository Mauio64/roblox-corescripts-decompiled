local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMarketplaceBundleStore = require(script.Parent.createMarketplaceBundleStore)

return Signals.createComputed(createMarketplaceBundleStore)
