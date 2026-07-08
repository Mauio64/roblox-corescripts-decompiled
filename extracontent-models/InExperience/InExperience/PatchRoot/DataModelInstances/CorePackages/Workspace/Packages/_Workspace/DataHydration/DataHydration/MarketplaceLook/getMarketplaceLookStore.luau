local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createMarketplaceLookStore = require(script.Parent.createMarketplaceLookStore)

return Signals.createComputed(createMarketplaceLookStore)
