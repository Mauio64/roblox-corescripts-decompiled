local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)
local createMomentsFollowingStore = require(script.Parent.createMomentsFollowingStore)

return Signals.createComputed(function(_)
	return createMomentsFollowingStore()
end)
