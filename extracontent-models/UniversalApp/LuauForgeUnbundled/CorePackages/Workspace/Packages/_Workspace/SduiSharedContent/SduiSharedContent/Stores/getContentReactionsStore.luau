local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Signals")

local createContentReactionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Stores/createContentReactionsStore")

return Signals.createComputed(createContentReactionsStore)
