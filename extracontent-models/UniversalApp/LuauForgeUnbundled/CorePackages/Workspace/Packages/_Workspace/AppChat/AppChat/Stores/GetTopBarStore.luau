local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore/createTopBarStore")

return Signals.createComputed(createTopBarStore)
