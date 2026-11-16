local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createMomentsStore = require(script.createMomentsStore)

return Signals.createComputed(function(_)
	return createMomentsStore()
end)
