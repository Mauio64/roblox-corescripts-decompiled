local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)

local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local GetConversationViewModelStore = require(AppChat.Stores.GetConversationViewModelStore)
local createConversationListStore = require(script.createConversationListStore)

return Signals.createComputed(function()
	return createConversationListStore(GetConversationStore(false), GetConversationViewModelStore(false))
end)
