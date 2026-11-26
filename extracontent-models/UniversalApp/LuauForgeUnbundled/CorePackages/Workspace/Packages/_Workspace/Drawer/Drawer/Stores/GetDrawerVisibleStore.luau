local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Signals")
local createDrawerVisibleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Stores/GetDrawerVisibleStore/createDrawerVisibleStore")

return Signals.createComputed(createDrawerVisibleStore)
