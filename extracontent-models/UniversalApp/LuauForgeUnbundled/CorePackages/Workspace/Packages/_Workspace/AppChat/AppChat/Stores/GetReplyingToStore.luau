local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createReplyingToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetReplyingToStore/createReplyingToStore")

return Signals.createComputed(createReplyingToStore)
