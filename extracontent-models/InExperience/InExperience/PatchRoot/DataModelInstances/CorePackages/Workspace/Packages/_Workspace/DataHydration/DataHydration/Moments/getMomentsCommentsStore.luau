local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMomentsCommentsStore = require(script.Parent.createMomentsCommentsStore)

return Signals.createComputed(function(_)
	return createMomentsCommentsStore()
end)
