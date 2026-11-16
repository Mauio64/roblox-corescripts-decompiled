local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMomentsStore = require(script.Parent.createMomentsStore)

return Signals.createComputed(function(_)
	return createMomentsStore()
end)
