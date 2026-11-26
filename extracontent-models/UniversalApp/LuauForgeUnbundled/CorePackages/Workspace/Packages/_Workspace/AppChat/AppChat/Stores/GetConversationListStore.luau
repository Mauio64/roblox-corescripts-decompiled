local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local GetConversationViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationViewModelStore")
local createConversationListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationListStore/createConversationListStore")

return Signals.createComputed(function()
	return createConversationListStore(GetConversationStore(false), GetConversationViewModelStore(false))
end)
