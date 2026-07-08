local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createMomentsStore = require(script.Parent.createMomentsStore)

return Signals.createComputed(function(_) -- line: 8
	-- upvalues: createMomentsStore (copy)
	return createMomentsStore()
end)
