local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createUniverseCreateStore = require(script.Parent.createUniverseCreateStore)

return Signals.createComputed(function() -- line: 9
	-- upvalues: createUniverseCreateStore (copy)
	return createUniverseCreateStore()
end)
