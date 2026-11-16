local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createPlaceVersionHistoryStore = require(script.Parent.createPlaceVersionHistoryStore)

return Signals.createComputed(function()
	return createPlaceVersionHistoryStore()
end)
