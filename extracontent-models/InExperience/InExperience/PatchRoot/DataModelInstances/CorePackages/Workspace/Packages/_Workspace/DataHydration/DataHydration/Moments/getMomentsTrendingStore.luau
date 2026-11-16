local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMomentsTrendingStore = require(script.Parent.createMomentsTrendingStore)

return Signals.createComputed(function(_)
	return createMomentsTrendingStore()
end)
