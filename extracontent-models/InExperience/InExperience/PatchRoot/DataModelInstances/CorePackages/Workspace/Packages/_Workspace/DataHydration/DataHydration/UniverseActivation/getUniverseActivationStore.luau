local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createUniverseActivationStore = require(script.Parent.createUniverseActivationStore)

return Signals.createComputed(function()
	return createUniverseActivationStore()
end)
