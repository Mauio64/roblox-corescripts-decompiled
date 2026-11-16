local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore/createConversationStore")

return Signals.createComputed(createConversationStore)
