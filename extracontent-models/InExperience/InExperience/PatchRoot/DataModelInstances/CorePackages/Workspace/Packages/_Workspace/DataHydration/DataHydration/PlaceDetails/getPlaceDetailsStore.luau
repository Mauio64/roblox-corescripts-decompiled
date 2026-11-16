local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createPlaceDetailsStore = require(script.Parent.createPlaceDetailsStore)

return Signals.createComputed(function()
	return createPlaceDetailsStore()
end)
