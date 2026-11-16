local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createReactionsStore = require(script.createReactionsStore)

return Signals.createComputed(function()
	return createReactionsStore()
end)
