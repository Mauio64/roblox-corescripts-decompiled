local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createIsPrivatePlaytesterStore = require(script.Parent.createIsPrivatePlaytesterStore)

return Signals.createComputed(function() -- line: 8
	-- upvalues: createIsPrivatePlaytesterStore (copy)
	return createIsPrivatePlaytesterStore()
end)
