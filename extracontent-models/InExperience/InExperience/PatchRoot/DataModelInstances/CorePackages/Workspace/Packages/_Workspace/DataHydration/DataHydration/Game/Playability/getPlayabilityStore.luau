local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createPlayabilityStore = require(script.Parent.createPlayabilityStore)

return Signals.createComputed(createPlayabilityStore)
