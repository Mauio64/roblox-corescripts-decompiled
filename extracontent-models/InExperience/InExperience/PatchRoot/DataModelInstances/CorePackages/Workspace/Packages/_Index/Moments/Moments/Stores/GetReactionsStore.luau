local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local createReactionsStore = require(script.createReactionsStore)

return Signals.createComputed(function() -- line: 7
	-- upvalues: createReactionsStore (copy)
	return createReactionsStore()
end)
