local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local createShareCountsStore = require(script.createShareCountsStore)

return Signals.createComputed(function() -- line: 11
	-- upvalues: createShareCountsStore (copy)
	return createShareCountsStore()
end)
