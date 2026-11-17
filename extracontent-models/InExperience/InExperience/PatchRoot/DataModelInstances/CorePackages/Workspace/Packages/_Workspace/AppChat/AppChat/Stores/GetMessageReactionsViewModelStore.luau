local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)

local GetMessageReactionsStore = require(AppChat.Stores.GetMessageReactionsStore)
local createMessageReactionsViewModelStore = require(script.createMessageReactionsViewModelStore)

return Signals.createComputed(function()
	return createMessageReactionsViewModelStore(GetMessageReactionsStore(false))
end)
