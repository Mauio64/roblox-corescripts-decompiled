local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createMomentsTrendingStore = require(script.Parent.createMomentsTrendingStore)

return Signals.createComputed(function(_) -- line: 8
	-- upvalues: createMomentsTrendingStore (copy)
	return createMomentsTrendingStore()
end)
