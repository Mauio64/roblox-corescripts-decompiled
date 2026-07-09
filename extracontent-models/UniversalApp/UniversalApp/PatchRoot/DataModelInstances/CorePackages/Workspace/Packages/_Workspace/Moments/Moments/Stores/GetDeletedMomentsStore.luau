local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local createDeletedMomentsStore = require(script.createDeletedMomentsStore)

return Signals.createComputed(function() -- line: 7
	-- upvalues: createDeletedMomentsStore (copy)
	return createDeletedMomentsStore()
end)
