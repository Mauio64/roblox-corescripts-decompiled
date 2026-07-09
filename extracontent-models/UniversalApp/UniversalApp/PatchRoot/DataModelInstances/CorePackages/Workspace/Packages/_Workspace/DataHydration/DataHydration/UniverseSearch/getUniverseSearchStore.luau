local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createUniverseSearchStore = require(script.Parent.createUniverseSearchStore)

return Signals.createComputed(function() -- line: 9
	-- upvalues: createUniverseSearchStore (copy)
	return createUniverseSearchStore()
end)
