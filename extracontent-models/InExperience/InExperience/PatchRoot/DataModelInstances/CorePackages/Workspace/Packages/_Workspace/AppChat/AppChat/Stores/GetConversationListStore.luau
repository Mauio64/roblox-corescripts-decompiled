local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Signals = require(AppChatParent.Signals)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local createConversationListStore = require(script.createConversationListStore)

return Signals.createComputed(function() -- line: 13
	-- upvalues: createConversationListStore (copy), GetConversationStore (copy)
	return createConversationListStore(GetConversationStore(false))
end)
