local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local GetConversationMessageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageStore")
local GetConversationMessageListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageListStore")
local createConversationMessageViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageViewModelStore/createConversationMessageViewModelStore")

return Signals.createComputed(function()
	return createConversationMessageViewModelStore(GetConversationMessageStore(false), (GetConversationMessageListStore(false)))
end)
