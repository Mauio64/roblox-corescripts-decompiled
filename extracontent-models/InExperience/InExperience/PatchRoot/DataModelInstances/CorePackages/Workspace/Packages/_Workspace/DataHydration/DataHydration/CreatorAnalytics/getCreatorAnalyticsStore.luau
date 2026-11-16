local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createCreatorAnalyticsStore = require(script.Parent.createCreatorAnalyticsStore)

return Signals.createComputed(function()
	return createCreatorAnalyticsStore()
end)
