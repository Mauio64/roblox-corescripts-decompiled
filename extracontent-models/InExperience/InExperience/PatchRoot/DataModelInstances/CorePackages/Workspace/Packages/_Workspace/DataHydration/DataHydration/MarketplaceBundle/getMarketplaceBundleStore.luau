local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createMarketplaceBundleStore = require(script.Parent.createMarketplaceBundleStore)

return Signals.createComputed(createMarketplaceBundleStore)
