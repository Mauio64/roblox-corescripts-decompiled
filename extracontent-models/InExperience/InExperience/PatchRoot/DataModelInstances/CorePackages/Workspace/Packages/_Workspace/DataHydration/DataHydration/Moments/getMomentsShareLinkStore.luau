local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createMomentsShareLinkStore = require(script.Parent.createMomentsShareLinkStore)

return Signals.createComputed(function(_) -- line: 9
	-- upvalues: createMomentsShareLinkStore (copy)
	return createMomentsShareLinkStore()
end)
