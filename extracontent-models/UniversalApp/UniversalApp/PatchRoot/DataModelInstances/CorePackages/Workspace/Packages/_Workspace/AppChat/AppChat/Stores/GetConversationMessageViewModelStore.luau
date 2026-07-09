local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Signals = require(AppChatParent.Signals)
local GetConversationMessageStore = require(AppChat.Stores.GetConversationMessageStore)
local GetConversationMessageListStore = require(AppChat.Stores.GetConversationMessageListStore)
local createConversationMessageViewModelStore = require(script.createConversationMessageViewModelStore)

return Signals.createComputed(function() -- line: 12
	-- upvalues: GetConversationMessageStore (copy), GetConversationMessageListStore (copy), createConversationMessageViewModelStore (copy)
	local v7 = GetConversationMessageStore(false)
	local v8 = GetConversationMessageListStore(false)

	return createConversationMessageViewModelStore(v7, v8)
end)
