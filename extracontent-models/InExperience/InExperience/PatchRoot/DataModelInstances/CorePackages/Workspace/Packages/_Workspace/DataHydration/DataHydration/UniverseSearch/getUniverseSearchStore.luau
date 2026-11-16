local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createUniverseSearchStore = require(script.Parent.createUniverseSearchStore)

return Signals.createComputed(function()
	return createUniverseSearchStore()
end)
