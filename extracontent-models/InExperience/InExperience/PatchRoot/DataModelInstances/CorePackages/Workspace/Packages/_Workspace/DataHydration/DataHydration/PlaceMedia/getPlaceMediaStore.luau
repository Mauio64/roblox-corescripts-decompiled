local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createPlaceMediaStore = require(script.Parent.createPlaceMediaStore)

return Signals.createComputed(function()
	return createPlaceMediaStore()
end)
