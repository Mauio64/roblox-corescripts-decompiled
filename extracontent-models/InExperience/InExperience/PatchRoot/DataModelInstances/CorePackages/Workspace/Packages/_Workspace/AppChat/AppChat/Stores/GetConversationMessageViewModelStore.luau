local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)

local GetConversationMessageStore = require(AppChat.Stores.GetConversationMessageStore)
local GetConversationMessageListStore = require(AppChat.Stores.GetConversationMessageListStore)
local createConversationMessageViewModelStore = require(script.createConversationMessageViewModelStore)

return Signals.createComputed(function()
	return createConversationMessageViewModelStore(
		GetConversationMessageStore(false),
		(GetConversationMessageListStore(false))
	)
end)
