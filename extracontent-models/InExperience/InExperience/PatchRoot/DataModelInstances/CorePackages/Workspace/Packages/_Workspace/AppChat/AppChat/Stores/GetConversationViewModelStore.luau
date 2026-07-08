local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Signals = require(AppChatParent.Signals)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local GetConversationMessageStore = require(AppChat.Stores.GetConversationMessageStore)
local createConversationViewModelStore = require(script.createConversationViewModelStore)

return Signals.createComputed(function() -- line: 12
	-- upvalues: GetConversationStore (copy), GetConversationMessageStore (copy), createConversationViewModelStore (copy)
	local v7 = GetConversationStore(false)
	local v8 = GetConversationMessageStore(false)

	return createConversationViewModelStore(v7, v8)
end)
