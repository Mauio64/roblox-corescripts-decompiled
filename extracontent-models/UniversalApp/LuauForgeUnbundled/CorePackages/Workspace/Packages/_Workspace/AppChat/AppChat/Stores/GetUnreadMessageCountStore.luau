local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createUnreadMessageCountStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetUnreadMessageCountStore/createUnreadMessageCountStore")

return Signals.createComputed(createUnreadMessageCountStore)
