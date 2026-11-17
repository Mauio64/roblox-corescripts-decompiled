local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createMomentsUsageStore = require(script.createMomentsUsageStore)

return Signals.createComputed(function(_)
	return createMomentsUsageStore()
end)
