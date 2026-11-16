local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createConversationMessageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageStore/createConversationMessageStore")

return Signals.createComputed(createConversationMessageStore)
