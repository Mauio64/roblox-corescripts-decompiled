local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createRootedNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetRootedNavigationStore/createRootedNavigationStore")

return Signals.createComputed(createRootedNavigationStore)
