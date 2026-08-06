local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createUniverseActivationStore = require(script.Parent.createUniverseActivationStore)

return Signals.createComputed(function() -- line: 8
	-- upvalues: createUniverseActivationStore (copy)
	return createUniverseActivationStore()
end)
