local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createMomentsReactionsStore = require(script.Parent.createMomentsReactionsStore)

return Signals.createComputed(function(_) -- line: 9
	-- upvalues: createMomentsReactionsStore (copy)
	return createMomentsReactionsStore()
end)
