local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local createModeratedItemsStore = require(script.createModeratedItemsStore)

return Signals.createComputed(function() -- line: 7
	-- upvalues: createModeratedItemsStore (copy)
	return createModeratedItemsStore()
end)
