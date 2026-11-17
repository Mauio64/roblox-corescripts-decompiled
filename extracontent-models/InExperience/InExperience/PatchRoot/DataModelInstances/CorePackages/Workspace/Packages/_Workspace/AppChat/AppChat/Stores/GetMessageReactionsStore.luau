local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createMessageReactionsStore = require(script.createMessageReactionsStore)

return Signals.createComputed(function(_)
	return createMessageReactionsStore()
end)
