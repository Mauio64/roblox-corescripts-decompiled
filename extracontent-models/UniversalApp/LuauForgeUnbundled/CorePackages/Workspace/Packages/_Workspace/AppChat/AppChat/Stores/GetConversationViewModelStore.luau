local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local GetConversationMessageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageStore")
local GetConversationMessageListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageListStore")
local createConversationViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationViewModelStore/createConversationViewModelStore")

return Signals.createComputed(function()
	return createConversationViewModelStore(GetConversationStore(false), GetConversationMessageStore(false), (GetConversationMessageListStore(false)))
end)
