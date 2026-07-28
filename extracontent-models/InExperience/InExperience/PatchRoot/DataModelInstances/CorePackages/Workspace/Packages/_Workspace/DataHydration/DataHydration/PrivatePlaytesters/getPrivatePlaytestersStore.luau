local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createPrivatePlaytestersStore = require(script.Parent.createPrivatePlaytestersStore)

return Signals.createComputed(function() -- line: 9
	-- upvalues: createPrivatePlaytestersStore (copy)
	return createPrivatePlaytestersStore()
end)
