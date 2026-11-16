local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/Signals")

local createModalSignalStore = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SignalStores/createModalSignalStore")

return Signals.createComputed(createModalSignalStore)
