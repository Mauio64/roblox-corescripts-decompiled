local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createPlayabilityStore = require(script.Parent.createPlayabilityStore)

return Signals.createComputed(createPlayabilityStore)
