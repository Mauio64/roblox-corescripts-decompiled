local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMomentsReactionsStore = require(script.Parent.createMomentsReactionsStore)

return Signals.createComputed(function(_)
	return createMomentsReactionsStore()
end)
