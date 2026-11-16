local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createShareCountsStore = require(script.createShareCountsStore)

return Signals.createComputed(function()
	return createShareCountsStore()
end)
