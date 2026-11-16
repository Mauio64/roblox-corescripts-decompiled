local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createConversationMessageListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageListStore/createConversationMessageListStore")

return Signals.createComputed(createConversationMessageListStore)
