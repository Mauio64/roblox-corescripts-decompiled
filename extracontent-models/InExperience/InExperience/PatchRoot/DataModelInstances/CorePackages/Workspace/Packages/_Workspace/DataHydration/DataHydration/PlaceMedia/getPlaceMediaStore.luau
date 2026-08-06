local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createPlaceMediaStore = require(script.Parent.createPlaceMediaStore)

return Signals.createComputed(function() -- line: 8
	-- upvalues: createPlaceMediaStore (copy)
	return createPlaceMediaStore()
end)
