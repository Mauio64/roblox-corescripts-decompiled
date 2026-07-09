local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createCreatorEligibilityStore = require(script.Parent.createCreatorEligibilityStore)

return Signals.createComputed(function() -- line: 9
	-- upvalues: createCreatorEligibilityStore (copy)
	return createCreatorEligibilityStore()
end)
