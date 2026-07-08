local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createMomentsUserStore = require(script.Parent.createMomentsUserStore)

return Signals.createComputed(function(_) -- line: 8
	-- upvalues: createMomentsUserStore (copy)
	return createMomentsUserStore()
end)
