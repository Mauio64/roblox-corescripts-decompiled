local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createCreatorEligibilityStore = require(script.Parent.createCreatorEligibilityStore)

return Signals.createComputed(function()
	return createCreatorEligibilityStore()
end)
