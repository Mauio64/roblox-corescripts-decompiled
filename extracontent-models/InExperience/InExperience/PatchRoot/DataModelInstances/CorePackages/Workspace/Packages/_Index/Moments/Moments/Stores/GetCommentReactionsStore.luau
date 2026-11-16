local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)
local createCommentReactionsStore = require(script.createCommentReactionsStore)

return Signals.createComputed(function()
	return createCommentReactionsStore()
end)
