local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMomentsShareLinkStore = require(script.Parent.createMomentsShareLinkStore)

return Signals.createComputed(function(_)
	return createMomentsShareLinkStore()
end)
