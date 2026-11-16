local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMomentsUserStore = require(script.Parent.createMomentsUserStore)

return Signals.createComputed(function(_)
	return createMomentsUserStore()
end)
