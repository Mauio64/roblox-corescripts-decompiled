local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local createMomentsStore = require(script.createMomentsStore)

return Signals.createComputed(function(_) -- line: 7
	-- upvalues: createMomentsStore (copy)
	return createMomentsStore()
end)
