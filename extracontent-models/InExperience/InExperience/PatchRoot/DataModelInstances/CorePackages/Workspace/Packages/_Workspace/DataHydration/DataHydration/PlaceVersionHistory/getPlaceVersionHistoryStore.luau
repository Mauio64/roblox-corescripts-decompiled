local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createPlaceVersionHistoryStore = require(script.Parent.createPlaceVersionHistoryStore)

return Signals.createComputed(function() -- line: 9
	-- upvalues: createPlaceVersionHistoryStore (copy)
	return createPlaceVersionHistoryStore()
end)
