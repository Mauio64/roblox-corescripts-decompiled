local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createModeratedItemsStore = require(script.createModeratedItemsStore)

return Signals.createComputed(function()
	return createModeratedItemsStore()
end)
