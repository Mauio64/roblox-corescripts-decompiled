local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createUniverseCreateStore = require(script.Parent.createUniverseCreateStore)

return Signals.createComputed(function()
	return createUniverseCreateStore()
end)
