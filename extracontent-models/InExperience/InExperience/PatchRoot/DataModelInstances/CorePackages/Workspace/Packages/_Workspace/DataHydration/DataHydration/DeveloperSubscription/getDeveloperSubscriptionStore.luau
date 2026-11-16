local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createDeveloperSubscriptionStore = require(script.Parent.createDeveloperSubscriptionStore)

return Signals.createComputed(function()
	return createDeveloperSubscriptionStore()
end)
