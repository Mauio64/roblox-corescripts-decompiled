local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMarketplaceLookStore = require(script.Parent.createMarketplaceLookStore)

return Signals.createComputed(createMarketplaceLookStore)
