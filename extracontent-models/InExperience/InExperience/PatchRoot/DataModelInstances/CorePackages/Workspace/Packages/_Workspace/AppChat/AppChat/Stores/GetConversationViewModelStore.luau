local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)

local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local GetConversationMessageStore = require(AppChat.Stores.GetConversationMessageStore)
local GetConversationMessageListStore = require(AppChat.Stores.GetConversationMessageListStore)
local createConversationViewModelStore = require(script.createConversationViewModelStore)

return Signals.createComputed(function()
	return createConversationViewModelStore(
		GetConversationStore(false),
		GetConversationMessageStore(false),
		(GetConversationMessageListStore(false))
	)
end)
